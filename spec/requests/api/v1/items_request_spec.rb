require "rails_helper"

describe "Item endpoints", :type => :request do
  let(:merchant) { Merchant.create!(name: "We got dogs") }
  let(:invalid_item_id) { 9999 }  # an ID that doesn't exist

  describe "GET all items" do
    it "should return a list of items" do
      create_list(:item, 3, merchant: create(:merchant))

      get "/api/v1/items"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data].count).to eq(3)
      expect(json[:data].first).to include(:id, :type, :attributes)
      expect(json[:data].first[:attributes]).to include(:name, :description, :unit_price)
    end

    it "should return items sorted by price when parameter is present" do
      middle = create(:item, unit_price: 50)
      cheap = create(:item, unit_price: 10)
      expensive = create(:item, unit_price: 100)

      get "/api/v1/items?sorted=price"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data][0][:attributes][:name]).to eq(cheap.name)
      expect(json[:data][1][:attributes][:name]).to eq(middle.name)
      expect(json[:data][2][:attributes][:name]).to eq(expensive.name)
    end
  end

  describe "GET item by id" do
    it "should return a single item by ID" do
      name = "toothpaste"
      description = "description"
      price = 45.55
      item = Item.create!(name: name, description: description, unit_price: price, merchant_id: Merchant.create(name: "test").id)

      get "/api/v1/items/#{item.id}"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data]).to include(:id, :type, :attributes)
      expect(json[:data][:id]).to eq("#{item.id}")
      expect(json[:data][:type]).to eq("item")
      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:attributes][:description]).to eq(description)
      expect(json[:data][:attributes][:unit_price]).to eq(price)
    end

    it "should return 404 and error message when item is not found" do
      get "/api/v1/items/100000"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to be_a Array
      expect(json[:errors].first).to eq("Couldn't find Item with 'id'=100000")
    end
  end

  describe "Create Item" do
    it "should create an item when all fields are provided" do
      name = "dog"
      desc = "here, have this new dog!"
      price = 12345
      body = {
        name: name,
        description: desc,
        unit_price: price,
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:attributes][:description]).to eq(desc)
      expect(json[:data][:attributes][:unit_price]).to eq(price)
    end

    it "should display an error message if not all fields are present" do
      body = {
        name: "name",
        description: "desc",
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:errors].first).to eq("Validation failed: Unit price can't be blank, Unit price is not a number")
    end

    it "should ignore unnecessary fields" do
      body = {
        name: "name",
        description: "desc",
        unit_price: 354.35,
        extra_field: "malicious stuff",
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes]).to_not include(:extra_field)
      expect(json[:data][:attributes]).to include(:name, :description, :unit_price, :merchant_id)
    end
  end

  describe "Update Item" do
    it "should properly update an existing item" do
      item = create(:item, merchant: merchant)
      item_name = "stamps"
      body = {
        name: item_name
      }
      patch "/api/v1/items/#{item.id}", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data][:attributes][:name]).to eq(item_name)
    end

    it "should return 404 when id provided is not valid" do
      body = {
        name: "new name"
      }

      patch "/api/v1/items/235", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:errors].first).to eq("Couldn't find Item with 'id'=235")
    end
  end

  describe "Delete Item" do
    it "should delete an item by id" do
      item = create(:item, merchant: merchant)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
    end

    it "should return 404 if id is invalid" do
      delete "/api/v1/items/678"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:not_found)
      expect(json[:errors].first).to eq("Couldn't find Item with 'id'=678")
    end
  end

end

