require 'rails_helper'

RSpec.describe 'Merchant Coupons API', type: :request do
  before(:each) do
    Faker::UniqueGenerator.clear
    @merchant = FactoryBot.create(:merchant)
    @coupon1 = FactoryBot.create(:coupon, merchant: @merchant, discount_type: 'percent', discount_value: 20)
    @coupon2 = FactoryBot.create(:coupon, merchant: @merchant, discount_type: 'dollar', discount_value: 10)
    @customer = FactoryBot.create(:customer)
    @invoice1 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant, coupon: @coupon1)
    @invoice2 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant, coupon: @coupon1)
  end

  describe 'GET /api/v1/merchants/:merchant_id/coupons/:id' do
    context 'when the coupon exists' do
      it 'returns the coupon details along with usage count' do
        get "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}"

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data][:id]).to eq(@coupon1.id.to_s)
        expect(json_response[:data][:attributes][:name]).to eq(@coupon1.name)
        expect(json_response[:data][:attributes][:discount_type]).to eq(@coupon1.discount_type)
        expect(json_response[:data][:attributes][:discount_value]).to eq(@coupon1.discount_value)
        expect(json_response[:data][:attributes][:active]).to eq(@coupon1.active)
        expect(json_response[:data][:attributes][:usage_count]).to eq(2)
      end
    end

    context 'when the coupon does not exist' do
      it 'returns a 404 error with the correct error message' do
        get "/api/v1/merchants/#{@merchant.id}/coupons/9999"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eq(['Your query could not be completed'])
      end
    end

    context 'when the merchant does not exist' do
      it 'returns a 404 error with the correct error message' do
        get "/api/v1/merchants/9999/coupons/#{@coupon1.id}"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eq(['Your query could not be completed'])
      end
    end
  end

  describe 'GET /api/v1/merchants/:merchant_id/coupons' do
    context 'when the merchant exists' do
      it 'returns all coupons for the merchant' do
        get "/api/v1/merchants/#{@merchant.id}/coupons"
        
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:data].length).to eq(2)
        expect(json_response[:data][0][:attributes][:merchant_id]).to eq(@merchant.id)
        expect(json_response[:data][1][:attributes][:merchant_id]).to eq(@merchant.id)
      end
    end

    context 'when the merchant does not exist' do
      it 'returns a 404 error' do
        get "/api/v1/merchants/9999/coupons"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eq(["Your query could not be completed"])
      end
    end
  end
end
