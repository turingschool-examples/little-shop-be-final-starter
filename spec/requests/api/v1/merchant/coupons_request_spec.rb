require 'rails_helper'

RSpec.describe "Coupons API", type: :request do
  describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
    before :each do
      @merchant = Merchant.create!(name: "Walmart")
      @coupon = @merchant.coupons.create!(name: "Discount", code: "SAVE10", value: 10, active: true)
    end

    it "returns the specified coupon" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to eq(@coupon.id.to_s)

      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(@coupon.name)

      expect(json[:data][:attributes]).to have_key(:code)
      expect(json[:data][:attributes][:code]).to eq(@coupon.code)

      expect(json[:data][:attributes]).to have_key(:value)
      expect(json[:data][:attributes][:value]).to eq(@coupon.value)

      expect(json[:data][:attributes]).to have_key(:active)
      expect(json[:data][:attributes][:active]).to eq(@coupon.active)
    end
  end
end