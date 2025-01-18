require "rails_helper"

RSpec.describe "Search Endpoints" do
  before :each do
    @merchant1 = Merchant.create!(name: "Crate and Barrel")
    @merchant2 = Merchant.create!(name: "Pier 1")
    @merchant3 = Merchant.create!(name: "crater lake artists")
    @merchant4 = Merchant.create!(name: "Plates R Us")
  end
  describe "find one merchant" do
    it "returns one merchant by name with case insensitive search" do
      get "/api/v1/merchants/find?name=ate"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("Crate and Barrel")
    end

    it "returns an empty data object if no merchant is found" do
      get "/api/v1/merchants/find?name=NOMATCH"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data]).to eq({})
    end

    it "returns an error if name is missing" do
      get "/api/v1/merchants/find"
      expect(response).to_not be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors][0]).to eq("Invalid search parameters provided")
    end

    it "returns an error if name is blank" do
      get "/api/v1/merchants/find?name="
      expect(response).to_not be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors][0]).to eq("Invalid search parameters provided")
    end
  end

  describe "find all merchants" do
    it "should return all merchants that satisfy search query" do
      get "/api/v1/merchants/find_all?name=ate"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      merchant_names = json[:data].map { |element| element[:attributes][:name] }
      expect(merchant_names).to match_array(["Crate and Barrel", "crater lake artists", "Plates R Us"])
    end

    it "returns an error if name is blank" do
      get "/api/v1/merchants/find_all?name="
      expect(response).to_not be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors][0]).to eq("Invalid search parameters provided")
    end
  end
end