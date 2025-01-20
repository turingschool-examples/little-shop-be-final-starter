require "rails_helper"

RSpec.describe "Merchant Coupons API", type: :request do
  describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
    it "returns merchant's coupon by coupon id" do
      merchant = create(:merchant)
      coupon = create(:coupon, merchant: merchant, full_name: "Spring Sale", code: "SPRING10")

      get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data][:id]).to eq(coupon.id)
      expect(json[:data][:type]).to eq("coupon")
      expect(json[:data][:attributes][:name]).to eq("Spring Sale")
      expect(json[:data][:attributes][:code]).to eq("SPRING10")
      expect(json[:data][:attributes][:merchant_id]).to eq(merchant.id)
    end
  

    it "returns a 404 error if the coupon does not exist for the given merchant" do
      merchant = create(:merchant)
        
      get "/api/v1/merchants/#{merchant.id}/coupons/99999"

      json = JSON.parse(response.body, symbolize_names: true)
      puts json 

      expect(response).to have_http_status(:not_found)
      expect(json[:error]).to eq("Coupon not found")
    end

    it "returns a 404 error if the merchant does not exist" do
      get "/api/v1/merchants/99999/coupons/1" 
      json = JSON.parse(response.body, symbolize_names: true) 
      
      expect(response).to have_http_status(:not_found) 
      expect(json[:error]).to eq("Coupon not found")
    end
  end
  
end