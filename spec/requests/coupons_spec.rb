require 'rails_helper'

RSpec.describe "Coupons", type: :request do
  describe "GET /show" do
    it 'return one coupon by id' do 
      merchant = Merchant.create!(id: 1, name: "Sample Merchant")
      coupon = Coupon.create!(name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"
      
    end
  end
end
