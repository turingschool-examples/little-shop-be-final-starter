require 'rails_helper'

RSpec.describe "Coupons", type: :request do
  describe "GET /api/v1/merchants/:merchant_id/coupons" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let!(:coupons) { FactoryBot.create_list(:coupon, 5, merchant: merchant, discount_type: 'dollar_off', discount_value: 10) }
    
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
    let(:coupon) { FactoryBot.create(:coupon, merchant: merchant, discount_type: 'dollar_off', discount_value: 10) }

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

  describe 'GET /api/v1/merchanrs/:merchant_id/coupons?status=' do
    let(:merchant) { FactoryBot.create(:merchant) }
    let!(:active_coupons) { FactoryBot.create_list(:coupon, 3, merchant: merchant, active: true, discount_type: 'dollar_off', discount_value: 10) }
    let!(:inactive_coupons) { FactoryBot.create_list(:coupon, 2, merchant: merchant, active: false, discount_type: 'percentage_off', discount_value: 20) }

    it 'only returns active coupons when status is selected as active' do
      get "/api/v1/merchants/#{merchant.id}/coupons", params: { status: 'active' }

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response['data'].count).to eq(3)
      json_response['data'].each do |coupon|
        expect(coupon['attributes']['active']).to be true
        expect(coupon['attributes']['discount_type']).to eq('dollar_off')
        expect(coupon['attributes']['discount_value'].to_f).to eq(10.0)
      end
    end

    it 'only returns inactive coupons when status is selected as inactive' do
      get "/api/v1/merchants/#{merchant.id}/coupons", params: { status: 'inactive' }

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      json_response['data'].each do |coupon|
        expect(coupon['attributes']['active']).to be false
        expect(coupon['attributes']['discount_type']).to eq('percentage_off')
        expect(coupon['attributes']['discount_value'].to_f).to eq(20.0)
      end
    end

    it 'returns all coupons when no status is selected' do
      get "/api/v1/merchants/#{merchant.id}/coupons", params: {}

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response['data'].count).to eq(5)
      end
    end

  end

  describe "POST /api/v1/merchants/:merchant_id/coupons" do
    before do
      @merchant = FactoryBot.create(:merchant)
      @valid_attributes = {
        name: "Sample Coupon",
        code: "ABC123",
        active: true,
        discount_type: 'dollar_off',
        discount_value: 10
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

    it 'does not create a coupon when request in valid' do
      expect {
        post "/api/v1/merchants/#{@merchant.id}/coupons", params: { coupon: @invalid_attributes }
      }.to change(Coupon, :count).by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("name")
    end
  end

  describe "PATCH /api/v1/merchants/:merchant_id/coupons:id/deactivate" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:coupon) { FactoryBot.create(:coupon, merchant: merchant, active: true, discount_type: 'dollar_off', discount_value: 10) }


    it 'deactivates the chosen active coupon' do
      expect(coupon.active).to be true

      patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}/deactivate"

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response['data']['id']).to eq(coupon.id.to_s)
      expect(json_response['data']['attributes']['active']).to eq(false)
    
      coupon.reload
      expect(coupon.active).to be false
    end
  end

  describe "PATCH /api/v1/merchants/:merchant_id/coupons:id/activate" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let!(:active_coupons) { FactoryBot.create_list(:coupon, 4, merchant: merchant, active: true, discount_type: 'dollar_off', discount_value: 10) } 
    let(:inactive_coupon) { FactoryBot.create(:coupon, merchant: merchant, active: false, discount_type: 'dollar_off', discount_value: 10) }

    it 'activates the coupon successfully when there are fewer than 5 active coupons' do
      patch "/api/v1/merchants/#{merchant.id}/coupons/#{inactive_coupon.id}/activate"

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response['data']['id']).to eq(inactive_coupon.id.to_s)
      expect(json_response['data']['attributes']['active']).to be true

      inactive_coupon.reload
      expect(inactive_coupon.active).to be true
    end

    context 'when there are 5 active coupons' do
      before do
        FactoryBot.create(:coupon, merchant: merchant, active: true, discount_type: 'dollar_off', discount_value: 10)
      end
  
      it 'does not activate the coupon and returns an error' do
        patch "/api/v1/merchants/#{merchant.id}/coupons/#{inactive_coupon.id}/activate"
  
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
  
        expect(json_response['error']).to eq("Maximum of 5 active coupons allowed.")
        
        inactive_coupon.reload
        expect(inactive_coupon.active).to be false
      end
    end
  end
end