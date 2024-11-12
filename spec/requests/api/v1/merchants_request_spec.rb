require "rails_helper"

describe "Merchant endpoints", :type => :request do
  describe "Get all merchants" do
    it "should return a properly array of merchants" do
      create_list(:merchant, 5)
      get "/api/v1/merchants"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data]).to be_a Array
      expect(json[:data].count).to eq(5)
      expect(json[:data].first).to include(:id, :type, :attributes)
      expect(json[:data].first[:attributes]).to include(:name)
    end

    it "should return a data key even when there are no merchants to return" do
      get "/api/v1/merchants"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json).to include(:data)
      expect(json[:data]).to be_empty
    end

    it "should return merchants sorted newest to oldest when sent sort param" do
      middle = Merchant.create!(name: "old merchant")
      first = Merchant.create!(name: "newer merchant")
      last = create(:merchant, created_at: 1.day.ago)

      get "/api/v1/merchants?sorted=age"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data][0][:attributes][:name]).to eq(first.name)
      expect(json[:data][1][:attributes][:name]).to eq(middle.name)
      expect(json[:data][2][:attributes][:name]).to eq(last.name)
    end

    it "should return merchants with invoices with status of returned when parameter is present" do
      customer = Customer.create!(first_name: "John", last_name: "Doe")
      merchant1 = Merchant.create!(name: "Merchant1")
      merchant2 = Merchant.create!(name: "Merchant2")
      Invoice.create!(status: "returned", customer_id: customer.id, merchant_id: merchant1.id)
      # The below factory_bot method will create 3 invoices
      create_list(:invoice, 3, status: "shipped", customer_id: customer.id, merchant_id: merchant1.id)
      Invoice.create!(status: "packaged", customer_id: customer.id, merchant_id: merchant2.id)
      Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant2.id)

      get "/api/v1/merchants?status=returned"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data].count).to eq(1)
      expect(json[:data][0][:id]).to eq(merchant1.id.to_s)
    end

    it "should return an item_count attribute when the param is present" do
      # This test uses FactoryBot methods to create a lot of test data quickly with random attributes
      # You do not need to use these factory bot methods in your project but you're welcome to try it.
      merchant = create(:merchant)
      create_list(:item, 10, merchant_id: merchant.id)

      merchant2 = create(:merchant)
      create_list(:item, 2, merchant_id: merchant2.id)

      merchant3 = create(:merchant)
      create_list(:item, 7, merchant_id: merchant3.id)

      get "/api/v1/merchants?count=true"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data][0][:attributes][:item_count]).to eq(10)
      expect(json[:data][1][:attributes][:item_count]).to eq(2)
      expect(json[:data][2][:attributes][:item_count]).to eq(7)
    end
  end

  describe "get a merchant by id" do
    it "should return a single merchant with the correct id" do
      merchant = Merchant.create!(name: "Joe & Sons")
      get "/api/v1/merchants/#{merchant.id}"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data]).to include(:id, :type, :attributes)
      expect(json[:data][:id]).to eq(merchant.id.to_s)
      expect(json[:data][:type]).to eq("merchant")
      expect(json[:data][:attributes]).to include(:name)
      expect(json[:data][:attributes][:name]).to eq(merchant.name)
    end

    it "should return 404 and error message when merchant is not found" do
      get "/api/v1/merchants/100"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to be_a Array
      expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=100")
    end
  end

  describe "create a merchant" do
    it "should successfully create when name is present" do
      name = "Crafty Coders"
      body = {
        name: name
      }

      post "/api/v1/merchants", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:type]).to eq("merchant")

      expect(Merchant.last.name).to eq(name)
    end

    it "should display an error message if not all fields are present" do

      post "/api/v1/merchants", params: {}, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:errors].first).to eq("Validation failed: Name can't be blank")
    end

    it "should ignore unnecessary fields" do
      body = {
        name: "Crafty Coders",
        address: "test",
        unit_price: 354.35,
        extra_field: "malicious stuff"
      }

      post "/api/v1/merchants", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes]).to_not include(:extra_field)
      expect(json[:data][:attributes]).to include(:name)
    end
  end

  describe "Update merchant" do
    it "should properly update an existing merchant" do
      merchant = create(:merchant)
      new_name = "new name"
      body = {
        name: new_name
      }
      patch "/api/v1/merchants/#{merchant.id}", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data][:attributes][:name]).to eq(new_name)
      expect(Merchant.find(merchant.id).name).to eq(new_name)
    end

    it "should return 404 when id provided is not valid" do
      body = {
        name: "new name"
      }

      patch "/api/v1/merchants/235", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=235")
    end
  end

  describe "Delete Merchant" do
    it "should delete a merchant by id" do
      merchant = create(:merchant)

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)
      expect(Merchant.find_by(id: merchant.id)).to be_nil
    end

    it "should return 404 if id is invalid" do
      delete "/api/v1/merchants/678"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:not_found)
      expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=678")
    end

    it "should successfully delete merchant and use cascading deletes if merchant has child records" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoices = create_list(:invoice, 5, merchant_id: merchant.id, customer_id: customer.id)
      items = create_list(:item, 5, merchant_id: merchant.id)
      InvoiceItem.create!(invoice: invoices[0], item: items[0], quantity: 5, unit_price: 100)
      delete "/api/v1/merchants/#{merchant.id}"
      
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'Merchant invoices and coupons' do
    it 'should retrun merchants with coupon counts' do
      merchant1 = create(:merchant)
      create_list(:coupon, 3, merchant: merchant1, status: "active")
      coupon1 = create(:coupon, merchant: merchant1, status: "active")

      merchant2 = create(:merchant)
      create_list(:coupon, 2, merchant: merchant2, status: "inactive")
      get "/api/v1/merchants"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data].count).to eq(2)
      expect(json[:data][0][:attributes][:coupons_count]).to eq(4)
      expect(json[:data][1][:attributes][:coupons_count]).to eq(2)
    end

    it 'should return merchants invoices with coupon counts' do
      customer = create(:customer)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      coupon1 = create(:coupon, merchant: merchant1)
      coupon2 = create(:coupon, merchant: merchant2)

      invoice1 = create(:invoice, customer: customer, merchant: merchant1, coupon: coupon1)
      create(:invoice, customer: customer, merchant: merchant1)

      invoice2 = create(:invoice, customer: customer, merchant: merchant2, coupon: coupon2)
      get "/api/v1/merchants"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data].count).to eq(2)

      expect(json[:data][0][:attributes][:invoice_coupon_count]).to eq(1)
      expect(json[:data][1][:attributes][:invoice_coupon_count]).to eq(1)
    end
  end
end