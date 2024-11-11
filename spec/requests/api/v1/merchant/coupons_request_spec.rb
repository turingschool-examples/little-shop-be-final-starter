require 'rails_helper'

RSpec.describe "Coupons API", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Walmart")
    @coupon1 = @merchant.coupons.create!(name: "Discount A", code: "SAVE10", value: 10, active: true)
    @coupon2 = @merchant.coupons.create!(name: "Discount B", code: "SAVE20", value: 20, active: false)
  end
  
  describe "coupon index" do
    it "returns all coupons for a specific merchant" do
      get "/api/v1/merchants/#{@merchant.id}/coupons"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(2)

      json[:data].each do |coupon|
        expect(coupon).to have_key(:id)
        expect(coupon[:attributes]).to have_key(:name)
        expect(coupon[:attributes]).to have_key(:code)
        expect(coupon[:attributes]).to have_key(:value)
        expect(coupon[:attributes]).to have_key(:active)
      end

      expect(json[:data][0][:attributes][:name]).to eq(@coupon1.name)
      expect(json[:data][1][:attributes][:name]).to eq(@coupon2.name)
    end
    
      it "returns an error if merchant ID doesn't exist" do
        get "/api/v1/merchants/9999/coupons"
        
        expect(response.status).to eq(404)
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(json[:message]).to eq("Your query could not be completed")
        expect(json[:errors]).to eq(["Merchant not found"])
      end

  describe "coupon show" do
    it "returns the specified coupon" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to eq(@coupon1.id.to_s)

      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(@coupon1.name)

      expect(json[:data][:attributes]).to have_key(:code)
      expect(json[:data][:attributes][:code]).to eq(@coupon1.code)

      expect(json[:data][:attributes]).to have_key(:value)
      expect(json[:data][:attributes][:value]).to eq(@coupon1.value)

      expect(json[:data][:attributes]).to have_key(:active)
      expect(json[:data][:attributes][:active]).to eq(@coupon1.active)

      expect(json[:data][:attributes]).to have_key(:used_count)
      expect(json[:data][:attributes][:used_count]).to eq(0)
    end

    it "returns an error if coupon ID doesn't exist" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/9999"

      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to eq(["Coupon not found"])
    end

    it "returns an error if merchant ID doesn't exist" do
      get "/api/v1/merchants/9999/coupons/#{@coupon1.id}"

      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to eq(["Merchant not found"])
    end
  end

    end
  end