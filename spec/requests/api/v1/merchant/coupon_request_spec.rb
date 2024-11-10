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
end