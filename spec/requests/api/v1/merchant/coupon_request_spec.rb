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

  describe 'should create a coupon' do
    it 'can create a coupon with correct parameters' do
      coupon_params = {
        name: 'Twenty Four Percent',
        code: 'TWENTY24',
        discount_type: 'percent_off',
        discount_value: 24.0,
        status: true,
      }

      post api_v1_merchant_coupons_path(merchant_id: merchant.id), params: { coupon: coupon_params}
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:name]).to eq('Twenty Four Percent')
      expect(json[:attributes][:code]).to eq('TWENTY24')
      expect(json[:attributes][:discount_type]).to eq('percent_off')
      expect(json[:attributes][:discount_value].to_f).to eq(24)
      expect(json[:attributes][:status]).to eq(true)
    end
  end

  describe 'should update a coupon' do
    let(:coupon) { create(:coupon, merchant: merchant) }

    it 'can update existing coupon' do
      updated_coupon = 'Updated!'
      patch api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id), params: { coupon: { name: updated_coupon } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:name]).to eq(updated_coupon)
    end
  end

  describe 'should update a coupon status' do
    let(:coupon) { create(:coupon, merchant: merchant, status: false) }

    it 'can change status of the coupon' do
      patch activate_api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:status]).to eq(true)
    end
  end

  describe 'should update a coupon status' do
    let(:coupon) { create(:coupon, merchant: merchant, status: true) }

    it 'can change status of the coupon' do
      patch deactivate_api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:status]).to eq(false)
    end
  end
end