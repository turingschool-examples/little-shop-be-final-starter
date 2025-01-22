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

    describe "Merchant Coupons Create" do
        it "creates a coupon successfully" do
            merchant = create(:merchant)
            coupon_params = { name: "New Discount", code: "BOGO50", discount_type: "percent_off", discount_amount: 20, status: "active" }
        
            post "/api/v1/merchants/#{merchant.id}/coupons", params: { coupon: coupon_params }
        
            expect(response).to have_http_status(:created)

            json = JSON.parse(response.body, symbolize_names: true)

            expect(json[:data][:attributes][:name]).to eq("New Discount")
            expect(json[:data][:attributes][:code]).to eq("BOGO50")
        end
      
        it "does not allow more than 5 active coupons" do
            merchant = create(:merchant)
            create_list(:coupon, 5, merchant: merchant, status: "active")
        
            coupon_params = { name: "Extra Discount", code: "BOGO50", discount_type: "percent_off", discount_amount: 50, status: "active" }

            post "/api/v1/merchants/#{merchant.id}/coupons", params: { coupon: coupon_params }
        
            expect(response).to have_http_status(:unprocessable_entity)

            json = JSON.parse(response.body, symbolize_names: true)

            expect(json[:error]).to eq("Merchant cannot have more than 5 active coupons")
        end
      end

    def deactivate
        merchant = Merchant.find(params[:merchant_id])
        coupon = merchant.coupons.find_by(id: params[:id]) # Use `find_by` to avoid exceptions
      
        if coupon.nil?
          render json: { error: "Coupon not found" }, status: :not_found
          return
        end
      
        if coupon.update(status: "inactive")
          render json: CouponSerializer.new(coupon), status: :ok
        else
          render json: { error: coupon.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
    end
end