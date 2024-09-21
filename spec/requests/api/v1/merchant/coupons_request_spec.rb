require 'rails_helper'

RSpec.describe "Coupons", type: :request do
  describe "GET /api/v1/merchants/:merchant_id/coupons" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let!(:coupons) { FactoryBot.create_list(:coupon, 5, merchant: merchant) }
    
    it 'creates coupons for the merchant' do
      expect(Coupon.count).to eq(5)
      expect(Coupon.where(merchant_id: merchant.id).count).to eq(5)
    end    

    it 'returns a list of coupons' do
      get "/api/v1/merchants/#{merchant.id}/coupons"

      expect(response).to be_successful
      json_response = JSON.parse(response.body)
      expect(json_response["data"].count).to eq(5)

      json_response['data'].each_with_index do |coupon, index|
        expect(coupon['type']).to eq('coupon')
        expect(coupon['attributes']['name']).to eq(coupons[index].name)
        expect(coupon['attributes']['code']).to eq(coupons[index].code)
        expect(coupon['attributes']['active']).to eq(coupons[index].active)
      end
    end
  end
end