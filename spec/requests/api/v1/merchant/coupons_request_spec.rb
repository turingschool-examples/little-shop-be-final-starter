require 'rails_helper'

RSpec.describe "Merchant Coupons Index", type: :request do
    describe "GET /api/v1/merchants/:merchant_id/coupons" do
        it "returns all coupons for a specific merchant" do
            merchant = create(:merchant)
            coupon1 = create(:coupon, merchant: merchant)
            coupon2 = create(:coupon, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons"

            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names: true)

            expect(json[:data].count).to eq(2)
            expect(json[:data].first[:attributes][:name]).to eq(coupon1.name)
            expect(json[:data].last[:attributes][:name]).to eq(coupon2.name)
        end

        it "returns an empty array if the merchant has no coupons" do
            merchant = create(:merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons"

            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names: true)

            expect(json[:data]).to eq([])
        end
    end

    describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
        it "returns a specific coupon" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)
            invoice = create(:invoice, coupon: coupon, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names: true)

            expect(json[:data][:attributes][:name]).to eq(coupon.name)
            expect(json[:data][:attributes][:code]).to eq(coupon.code)
            expect(json[:data][:attributes][:usage_count]).to eq(1) # used 1 time, else you have issues in DB with repeaters
        end
    end
end