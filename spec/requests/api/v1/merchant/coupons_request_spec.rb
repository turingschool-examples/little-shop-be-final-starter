require 'rails_helper'

RSpec.describe "Coupons", type: :request do
  describe "GET /show" do
    it 'return one coupon by id' do 
      merchant = Merchant.create!(id: 1, name: "Sample Merchant")
      coupon = Coupon.create!(name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      expect(response).to have_http_status(200)
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      
      expect(json_response['data']['id']).to eq(coupon.id.to_s)
      expect(json_response['data']['type']).to eq('coupon')
      expect(json_response['data']['attributes']['name']).to eq(coupon.name)
      expect(json_response['data']['attributes']['code']).to eq(coupon.code)
      expect(json_response['data']['attributes']['discount_value']).to be_a(String)
      expect(json_response['data']['attributes']['active']).to eq(coupon.active?)
      expect(json_response['data']['attributes']['merchant_id']).to eq(coupon.merchant_id)
    end

    it 'returns a 404 when a coupon does not exist' do
      merchant = Merchant.create!(id: 1, name: "Sample Merchant")

      get "/api/v1/merchants/#{merchant.id}/coupons/9999"

      expect(response).to have_http_status(404)
      json_response = JSON.parse(response.body)
      
      expect(json_response['message']).to include("Your query could not be completed")
      expect(json_response['errors']).to include("Couldn't find Coupon with 'id'=9999")
    end
  end

  describe 'GET/index' do
    it 'returns all coupons for certain merchant id' do 
      merchant = Merchant.create!(id: 1, name: "Sample Merchant")
      Coupon.create!(name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true, merchant_id: merchant.id)
      Coupon.create!(name: "Buy One Get One 40", code: "BOGO40", discount_value: 40, active: true, merchant_id: merchant.id)
      Coupon.create!(name: "Buy One Get One 30", code: "BOGO30", discount_value: 30, active: false, merchant_id: merchant.id)
      Coupon.create!(name: "Buy One Get One 20", code: "BOGO20", discount_value: 20, active: false, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/coupons"

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json_response.size).to eq(4)
      
      json_response.each do |coupon|
        expect(coupon[:id]).to be_a(String)
        expect(coupon[:type]).to eq('coupon')
        expect(coupon[:attributes]).to have_key(:id)
        expect(coupon[:attributes][:id]).to be_an(Integer)
        expect(coupon[:attributes][:name]).to be_a(String)
        expect(coupon[:attributes][:code]).to be_a(String)
        expect(coupon[:attributes][:discount_value]).to be_a(String)
        expect([true, false]).to include(coupon[:attributes][:active])
        expect(coupon[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  
      it 'returns an error is there is no merchant with that id' do 
        merchant = Merchant.create!(id: 1, name: "Sample Merchant")
        Coupon.create!(name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true, merchant_id: merchant.id)
        Coupon.create!(name: "Buy One Get One 40", code: "BOGO40", discount_value: 40, active: true, merchant_id: merchant.id)
        Coupon.create!(name: "Buy One Get One 30", code: "BOGO30", discount_value: 30, active: false, merchant_id: merchant.id)
        Coupon.create!(name: "Buy One Get One 20", code: "BOGO20", discount_value: 20, active: false, merchant_id: merchant.id)

        get "/api/v1/merchants/9999/coupons"
        
        expect(response).to have_http_status(404)
        
        json_response = JSON.parse(response.body)
      
        expect(json_response['message']).to include("Your query could not be completed")
        expect(json_response['errors']).to include("Couldn't find Merchant with 'id'=9999")
      end
    end

    describe 'POST' do 
      it 'creates a new coupon' do 
        merchant = Merchant.create!(name: "Sample Merchant")
        coupon_params = { name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true }

        post "/api/v1/merchants/#{merchant.id}/coupons", params: { coupon: coupon_params }

        expect(response).to have_http_status(201)

        created_coupon = Coupon.last
        expect(created_coupon.name).to eq("Buy One Get One 50")
        expect(created_coupon.code).to eq("BOGO50")
        expect(created_coupon.discount_value).to eq(50)
        expect(created_coupon.active).to be_truthy
        expect(created_coupon.merchant_id).to eq(merchant.id)
      end
    end

    describe 'PATCH' do 
      it 'updates a coupon from active to inactive' do 
        merchant = Merchant.create!(name: "Sample Merchant")
        coupon = Coupon.create!(name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: true, merchant_id: merchant.id)
        coupon_params = { name: "Buy One Get One 50", code: "BOGO50", discount_value: 50, active: false, merchant_id: merchant.id}

        patch "/api/v1/merchants/#{merchant.id}/coupons//#{coupon.id}", params: { coupon: coupon_params }
        
        expect(response).to have_http_status(200)

        updated_coupon = JSON.parse(response.body, symbolize_names: true)
        
        expect(updated_coupon).to have_key(:data)
        expect(updated_coupon[:data]).to have_key(:id)
        expect(updated_coupon[:data][:id]).to be_a(String)
        expect(updated_coupon[:data][:type]).to eq('coupon')
        expect(updated_coupon[:data]).to have_key(:attributes)
        expect(updated_coupon[:data][:attributes]).to have_key(:id)
        expect(updated_coupon[:data][:attributes][:id]).to be_an(Integer)
        expect(updated_coupon[:data][:attributes]).to have_key(:name)
        expect(updated_coupon[:data][:attributes][:name]).to be_a(String)
        expect(updated_coupon[:data][:attributes]).to have_key(:code)
        expect(updated_coupon[:data][:attributes][:code]).to be_a(String)
        expect(updated_coupon[:data][:attributes]).to have_key(:discount_value)
        expect(updated_coupon[:data][:attributes][:discount_value]).to be_a(String)
        expect(updated_coupon[:data][:attributes]).to have_key(:active)
        expect(updated_coupon[:data][:attributes][:active]).to eq(false)
        expect(updated_coupon[:data][:attributes]).to have_key(:merchant_id)
        expect(updated_coupon[:data][:attributes][:merchant_id]).to be_an(Integer)
      end
    end
end