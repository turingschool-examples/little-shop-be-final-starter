require 'rails_helper'

RSpec.describe 'Merchant Coupons endpoints' do
  let(:merchant) { create(:merchant) }

  before :each do
    create_list(:coupon, 3, merchant: merchant)
    create_list(:coupon, 2, :inactive, merchant: merchant)
  end

  describe 'should return coupon info for given merchant' do
    it 'returns all coupons for given merchant' do
      get api_v1_merchant_coupons_path(merchant_id: merchant.id)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].size).to eq(5)
    end
  end

  describe 'should return a single coupon' do
    let(:coupon) { create(:coupon, merchant: merchant) }

    it 'returns details of a single coupon' do
      get api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id)
      expect(response).to have_http_status(:ok)    
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(json[:id]).to eq(coupon.id.to_s)
      expect(json[:attributes][:name]).to eq(coupon.name)
      expect(json[:attributes][:code]).to eq(coupon.code)
      expect(json[:attributes][:discount_type]).to eq(coupon.discount_type)
      expect(json[:attributes][:discount_value].to_f).to eq(coupon.discount_value.to_f)
      expect(json[:attributes][:status]).to eq(coupon.status)
    end
  end
end