require "rails_helper"

RSpec.describe "Merchant Coupons Show", type: :request do
    describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
        it "returns merchant coupons for specified merchant" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names: true)
            # puts response.body

            expect(json[:data][:id]).to eq(coupon.id.to_s)
            expect(json[:data][:attributes][:name]).to eq(coupon.name)
            expect(json[:data][:attributes][:usage_count]).to eq(coupon.invoices.count)
        end

        it "returns a 404 error if the coupon doesn't exist" do
            merchant = create(:merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons/999"

            expect(response.status).to eq(404)
            # puts response.status

            json = JSON.parse(response.body, symbolize_names: true)

            expect(json[:error]).to eq("Coupon not found")
        end
    end
end