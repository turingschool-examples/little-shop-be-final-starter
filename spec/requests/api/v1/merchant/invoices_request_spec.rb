require "rails_helper"

RSpec.describe "Merchant invoices endpoints" do
  before :each do
    @merchant2 = Merchant.create!(name: "Merchant")
    @merchant1 = Merchant.create!(name: "Merchant Again")

    @customer1 = Customer.create!(first_name: "Papa", last_name: "Gino")
    @customer2 = Customer.create!(first_name: "Jimmy", last_name: "John")

    @coupon = Coupon.create!(name: "Something Off", code: "DISCOUNT10", discount_type: "percent_off", discount_value: 10.0, status: true, merchant: @merchant1)

    @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "packaged")
    Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped")
    Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped")
    Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped")
    @invoice2 = Invoice.create!(customer: @customer1, merchant: @merchant2, status: "shipped")

    @invoice_with_coupon = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon: @coupon)
  end

  it "should return all invoices for a given merchant based on status param" do
    get "/api/v1/merchants/#{@merchant1.id}/invoices?status=packaged"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(1)
    expect(json[:data][0][:id]).to eq(@invoice1.id.to_s)
    expect(json[:data][0][:type]).to eq("invoice")
    expect(json[:data][0][:attributes][:customer_id]).to eq(@customer1.id)
    expect(json[:data][0][:attributes][:merchant_id]).to eq(@merchant1.id)
    expect(json[:data][0][:attributes][:status]).to eq("packaged")
  end

  it "should get multiple invoices if they exist for a given merchant and status param" do
    get "/api/v1/merchants/#{@merchant1.id}/invoices?status=shipped"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(4)
  end

  it "should only get invoices for merchant given" do
    get "/api/v1/merchants/#{@merchant2.id}/invoices?status=shipped"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(1)
    expect(json[:data][0][:id]).to eq(@invoice2.id.to_s)
  end

  it "should return 404 and error message when merchant is not found" do
    get "/api/v1/merchants/100000/customers"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:not_found)
    expect(json[:message]).to eq("Your query could not be completed")
    expect(json[:errors]).to be_a Array
    expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=100000")
  end

  describe 'handling coupons' do
    it "should add a coupon to an invoice" do
      get "/api/v1/merchants/#{@merchant1.id}/invoices?status=shipped"

      json = JSON.parse(response.body, symbolize_names: true)
      
      invoice_with_coupon = json[:data].find { |invoice| invoice[:id] == @invoice_with_coupon.id.to_s }
      expect(invoice_with_coupon[:attributes][:coupon_id]).to eq(@coupon.id)
    end

    it "should return null if the package is pending" do
      get "/api/v1/merchants/#{@merchant1.id}/invoices?status=packaged"

      json = JSON.parse(response.body, symbolize_names: true)
    
      expect(response).to be_successful
      expect(json[:data].count).to eq(1)
      expect(json[:data][0][:attributes][:coupon_id]).to be_nil
    end
  end
end