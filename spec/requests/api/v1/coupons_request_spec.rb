require "rails_helper"

RSpec.describe "Coupons endpoints", :type => :request do
  before(:each) do
    @merchants = create_list(:merchant, 3)

    @customers = create_list(:customer, 3)
    
    @coupon1 = create(:coupon, name: '50% Off Next Repair', code: '50PONRP', dollar_off: nil, percent_off: 50, status: 'active', merchant_id: @merchants[0].id)
    @coupon2 = create(:coupon, name: '10% Off Next Repair', code: '10PONRP', dollar_off: nil, percent_off: 10, status: 'active', merchant_id: @merchants[0].id)
    @coupon3 = create(:coupon, name: '15% off lentil tacos', code: '15PLT', dollar_off: nil, percent_off: 15, status: 'active', merchant_id: @merchants[1].id)
    @coupon4 = create(:coupon, name: '5 Dollars Off Sweet Tea', code: '5DOFF', dollar_off: 5.0, percent_off: nil, status: 'inactive', merchant_id: @merchants[1].id)
    @coupon5 = create(:coupon, name: '20% Off Second Necklace', code: '20P2NDNL', dollar_off: nil, percent_off: 20, status: 'active', merchant_id: @merchants[2].id)
    @coupon6 = create(:coupon, name: '10 Dollars Off Any Bracelet', code: '10DOB', dollar_off: 10, percent_off: nil, status: 'active', merchant_id: @merchants[2].id)

    @invoice1 = create(:invoice, customer_id: @customers[0].id, merchant_id: @merchants[0].id, status: 'shipped', coupon_id: @coupon1.id)
    @invoice2 = create(:invoice, customer_id: @customers[0].id, merchant_id: @merchants[0].id, status: 'shipped', coupon_id: @coupon2.id)
    @invoice3 = create(:invoice, customer_id: @customers[1].id, merchant_id: @merchants[1].id, status: 'shipped', coupon_id: @coupon3.id)
    @invoice4 = create(:invoice, customer_id: @customers[2].id, merchant_id: @merchants[2].id, status: 'shipped', coupon_id: @coupon6.id)
    @invoice5 = create(:invoice, customer_id: @customers[2].id, merchant_id: @merchants[2].id, status: 'shipped', coupon_id: @coupon6.id)
    @invoice6 = create(:invoice, customer_id: @customers[2].id, merchant_id: @merchants[2].id, status: 'shipped', coupon_id: @coupon6.id)

  end

  describe 'JSON Response Structure' do
    it 'Confirms the correct data types of a coupon' do
      get "/api/v1/coupons/#{@coupon6.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      coupon = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(coupon[:id]).to be_a(String)
      expect(coupon[:type]).to be_a(String)
      expect(coupon[:type]).to eq('coupon')

      expect(coupon[:attributes][:name]).to be_a(String)
      expect(coupon[:attributes][:code]).to be_a(String)
      expect(coupon[:attributes][:dollar_off]).to be_a(Float).or eq(nil)
      expect(coupon[:attributes][:percent_off]).to be_a(Integer).or eq(nil)
      expect(coupon[:attributes][:status]).to be_a(String)
      expect(coupon[:attributes][:status]).to eq('active').or eq('inactive')
      expect(coupon[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'GET /api/v1/coupons/:id' do
    it 'Confirms correct coupon w/ usage_count attribute on JSON response.' do
      get "/api/v1/coupons/#{@coupon6.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      coupon_data = JSON.parse(response.body, symbolize_names: true)[:data]
      coupon_meta = JSON.parse(response.body, symbolize_names: true)[:meta]

      expect(coupon_data[:id].to_i).to eq(@coupon6.id)
      expect(coupon_data[:type]).to eq('coupon')

      expect(coupon_data[:attributes][:name]).to eq(@coupon6.name)
      expect(coupon_data[:attributes][:code]).to eq(@coupon6.code)
      expect(coupon_data[:attributes][:dollar_off]).to eq(@coupon6.dollar_off)
      expect(coupon_data[:attributes][:percent_off]).to eq(@coupon6.percent_off)
      expect(coupon_data[:attributes][:status]).to eq(@coupon6.status)
      expect(coupon_data[:attributes][:merchant_id]).to eq(@coupon6.merchant_id)

      expect(coupon_meta[:usage_count]).to eq(3)

    end
  end

  describe 'SAD PATH: GET /api/v1/coupons/:id' do
    it 'Returns 404 Error when provided invalid coupon ID' do
      get "/api/v1/coupons/133713371337"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end