require 'rails_helper'

RSpec.describe "Coupons", type: :request do
  describe "GET /show" do
    it 'return one coupon by id' do 
      merchant = Merchant.create!(id: 1, name: "Sample Merchant")
      coupon = Coupon.create!(name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      expect(response).to have_http_status(200)
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      
      expect(json_response['data']['id']).to eq(coupon.id.to_s)
      expect(json_response['data']['type']).to eq('coupon')
      expect(json_response['data']['attributes']['name']).to eq(coupon.name)
      expect(json_response['data']['attributes']['code']).to eq(coupon.code)
      expect(json_response['data']['attributes']['discount_value']).to be_a(String)
      expect(json_response['data']['attributes']['active']).to eq(coupon.active?)
      expect(json_response['data']['attributes']['merchant_id']).to eq(coupon.merchant_id)
    end

    it 'returns a 404 when a coupon does not exist' do
      merchant = Merchant.create!(id: 1, name: "Sample Merchant")

      get "/api/v1/merchants/#{merchant.id}/coupons/9999"

      expect(response).to have_http_status(404)
      json_response = JSON.parse(response.body)
      

      expect(json_response).to include("message" => "Your query could not be completed")
      expect(json_response['errors']).to include("Couldn't find Coupon with 'id'=9999")
    end
  end
end
