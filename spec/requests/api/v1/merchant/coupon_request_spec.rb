require 'rails_helper'

RSpec.describe 'Merchant Coupons endpoints' do
  let(:merchant) { create(:merchant) }

  before :each do
    create_list(:coupon, 3, merchant: merchant, status: 'active')
    create_list(:coupon, 2, merchant: merchant, status: 'inactive')
  end

  describe 'should return coupon info for given merchant' do
    it 'returns all coupons for given merchant' do
      get api_v1_merchant_coupons_path(merchant_id: merchant.id)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].size).to eq(5)
    end

    it 'returns only active coupons when filtered for active' do
      get api_v1_merchant_coupons_path(merchant_id: merchant.id), params: { status: 'active'}
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(3)
      expect(json[:data].all? { |coupon| coupon[:attributes][:status] == 'active' } ).to be true
    end

    it 'returns only inactive coupons when filtered for inactive' do
      get api_v1_merchant_coupons_path(merchant_id: merchant.id), params: { status: 'inactive'}
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(2)
      expect(json[:data].all? { |coupon| coupon[:attributes][:status] == 'inactive' } ).to be true
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
        status: 'active'
      }

      post api_v1_merchant_coupons_path(merchant_id: merchant.id), params: { coupon: coupon_params}
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:name]).to eq('Twenty Four Percent')
      expect(json[:attributes][:code]).to eq('TWENTY24')
      expect(json[:attributes][:discount_type]).to eq('percent_off')
      expect(json[:attributes][:discount_value].to_f).to eq(24)
      expect(json[:attributes][:status]).to eq('active')
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
    let(:coupon) { create(:coupon, merchant: merchant, status: 'inactive') }

    it 'can change status of the coupon to active' do
      patch activate_api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:status]).to eq('active')
    end
  end

  describe 'should update a coupon status' do
    let(:coupon) { create(:coupon, merchant: merchant, status: 'active') }

    it 'can change status of the coupon to inactive' do
      patch deactivate_api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:status]).to eq('inactive')
    end
  end

  describe 'sad paths' do
    let(:coupon) { create(:coupon, merchant: merchant) }

    it 'returns a 404 status updating invalid coupon' do
      patch api_v1_merchant_coupon_path(merchant_id: merchant.id, id: 0), params: { coupon: { name: '' } }

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors].first).to include("Couldn't find Coupon with 'id'=0")
    end

    it 'returns a 422 status with invalid params' do
      patch api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id), params: {coupon: { status: ''} }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors]).to include('Invalid parameters provided')
    end

    it 'returns a 404 when creating an invalid coupon' do
      invalid_coupon_params = {}
  
      post api_v1_merchant_coupons_path(merchant_id: merchant.id), params: invalid_coupon_params
  
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors]).to include('Invalid parameters provided')
    end

    it 'returns a 422 status when creating a coupon with invalid parameters' do
      incomplete_coupon_params = {
        coupon: {
          code: 'TWENTY24',
        }
      }
  
      post api_v1_merchant_coupons_path(merchant_id: merchant.id), params: incomplete_coupon_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors]).to include("Name can't be blank", "Discount value can't be blank")
    end
  end
end