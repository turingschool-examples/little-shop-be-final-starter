require 'rails-helper'

RSpec.describe 'Merchant Coupons', type: :request do
  before(:each) do
    @merchant = FactoryBot.create(:merchant)
    @coupon1 = FactoryBot.create(:coupon, merchant: @merchant, discount_type: 'percent', discount_value: 20)
    @coupon2 = FactoryBot.create(:coupon, merchant: @merchant, discount_type: 'dollar', discount_value: 10)
    @coupon3 = FactoryBot.create(:coupon, merchant: @merchant, discount_type: 'percent', discount_value: 15, active: false)

    @customer = FactoryBot.create(:customer)
    @invoice1 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant, coupon: @coupon1)
    @invoice2 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant, coupon: @coupon1)
    @invoice3 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant, coupon: @coupon2)
  end

  describe 'GET /api/v1/coupons/:id' do
    it 'returns the coupon details along with usage count' do
      get "/api/v1/coupons/#{@coupon.id}"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:data][:id]).to eq(@coupon.id.to_s)
      expect(json_response[:data][:type]).to eq('coupon')
      expect(json_response[:data][:attributes][:name]).to eq(@coupon.name)
      expect(json_response[:data][:attributes][:usage_count]).to eq(2)
      expect(json_response[:data][:attributes][:merchant_name]).to eq(@merchant.name)
    end

    it 'returns a 404 error if the coupon does not exist' do
      get "/api/v1/coupons/999"
      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:error]).to eq('Coupon not found')
    end
  end
end