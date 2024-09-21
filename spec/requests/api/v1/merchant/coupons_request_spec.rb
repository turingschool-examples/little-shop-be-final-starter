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

  describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:coupon) { FactoryBot.create(:coupon,merchant: merchant) }

    it 'returns a specific coupons details' do
      get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      expect(response).to be_successful
      json_response = JSON.parse(response.body)
  
      expect(json_response["data"]["id"]).to eq(coupon.id.to_s)
      expect(json_response["data"]["type"]).to eq("coupon")
      expect(json_response["data"]["attributes"]["name"]).to eq(coupon.name)
      expect(json_response["data"]["attributes"]["code"]).to eq(coupon.code)
      expect(json_response["data"]["attributes"]["active"]).to eq(coupon.active)
    end
  end

  describe "POST /api/v1/merchants/:merchant_id/coupons" do
    before do
      @merchant = FactoryBot.create(:merchant)
      @valid_attributes = {
        name: "Sample Coupon",
        code: "ABC123",
        active: true
      }

      @invalid_attributes = {
        name: nil,
        code: "ABC123",
        active: true
      }
    end

    it 'creates a new coupon when request is valid' do
      expect {
        post "/api/v1/merchants/#{@merchant.id}/coupons", params: { coupon: @valid_attributes }
      }.to change(Coupon, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)

      expect(json_response).to have_key("data")
      expect(json_response["data"]).to have_key("attributes")
      expect(json_response["data"]["attributes"]["name"]).to eq("Sample Coupon")
    end
  end
end