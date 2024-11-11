require "rails_helper"

RSpec.describe "Item search endpoints" do
  before :each do
    @item1 = create(:item, name: "Widget", unit_price: 50)
    @item2 = create(:item, name: "Gadget", unit_price: 75)
    @item3 = create(:item, name: "Widget Pro", unit_price: 100)
  end

  describe "GET /api/v1/items/find" do
    context "when searching by name" do
      it "returns a single item by name" do
        get "/api/v1/items/find", params: { name: "Widget" }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data][:attributes][:name]).to eq("Widget")
      end

      it "returns an empty response when no item matches" do
        get "/api/v1/items/find", params: { name: "Nonexistent" }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data]).to be_empty
      end
    end

    context "when searching by price" do
      it "returns an item within a min price" do
        get "/api/v1/items/find", params: { min_price: 60 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data][:attributes][:unit_price]).to be >= 60
      end

      it "returns an item within a max price" do
        get "/api/v1/items/find", params: { max_price: 60 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data][:attributes][:unit_price]).to be <= 60
      end

      it "returns an empty response when no item is in price range" do
        get "/api/v1/items/find", params: { min_price: 200 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data]).to be_empty
      end

      it "returns a 400 error when min price is greater than max price" do
        get "/api/v1/items/find", params: { min_price: 100, max_price: 50 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("your query could not be completed")
      end
    end
  end

  describe "GET /api/v1/items/find_all" do
    context "when searching by name" do
      it "returns multiple items by name" do
        get "/api/v1/items/find_all", params: { name: "Widget" }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data].count).to eq(2)
        expect(json[:data].map { |item| item[:attributes][:name] }).to include("Widget", "Widget Pro")
      end
    end

    context "when searching by price" do
      it "returns items within a min price range" do
        get "/api/v1/items/find_all", params: { min_price: 60 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data].all? { |item| item[:attributes][:unit_price] >= 60 }).to be true
      end

      it "returns items within a max price range" do
        get "/api/v1/items/find_all", params: { max_price: 60 }

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(json[:data].all? { |item| item[:attributes][:unit_price] <= 60 }).to be true
      end
    end
  end

  describe "validation errors" do
    it "returns a 400 error when name is combined with price filters" do
      get "/api/v1/items/find", params: { name: "Widget", min_price: 50 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:bad_request)
      expect(json[:message]).to eq("your query could not be completed")
    end

    it "returns a 400 error when min_price is negative" do
      get "/api/v1/items/find", params: { min_price: -10 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:bad_request)
      expect(json[:message]).to eq("your query could not be completed")
    end

    it "returns a 400 error when max_price is negative" do
      get "/api/v1/items/find", params: { max_price: -20 }

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:bad_request)
      expect(json[:message]).to eq("your query could not be completed")
    end

    it "returns a 400 error when no search parameters are provided" do
      get "/api/v1/items/find"

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:bad_request)
      expect(json[:message]).to eq("your query could not be completed")
    end
  end
end