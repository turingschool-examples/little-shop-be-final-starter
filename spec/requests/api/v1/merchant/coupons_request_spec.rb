# bundle exec rspec spec/requests/api/v1/merchant/coupons_request_spec.rb
require "rails_helper"

RSpec.describe "Merchant Coupon endpoints" do
  before :each do
    @merchant1 = create(:merchant)
    @coupon1 = create(:coupon, merchant: @merchant1)
    
    @merchant2 = create(:merchant)
    @coupon2 = create(:coupon, merchant: @merchant2, code: "10PER", percent_off: 10)
    @coupon3 = create(:coupon, merchant: @merchant2,code: "5OFF", dollar_off: 5)
  end

  it "should return all of a merchant's coupons" do
    get "/api/v1/merchants/#{@merchant1.id}/coupons"

    coupons = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(coupons[:data].count).to eq(1)
    expect(coupons[:data][0][:id]).to eq(@coupon1.id.to_s)
    expect(coupons[:data][0][:type]).to eq("coupon")
    expect(coupons[:data][0][:attributes][:name]).to eq(@coupon1.name)
    expect(coupons[:data][0][:attributes][:code]).to eq(@coupon1.code)
    expect(coupons[:data][0][:attributes][:percent_off]).to eq(@coupon1.percent_off.to_s)
    expect(coupons[:data][0][:attributes][:dollar_off]).to eq(@coupon1.dollar_off)
    expect(coupons[:data][0][:attributes][:used_count]).to eq(@coupon1.used_count)
  end

  describe 'Merchant Coupon Show' do
    it 'returns a specific coupon with a count of how many times coupon has been used' do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      coupons = JSON.parse(response.body, symbolize_names: true)

      expect(coupons[:data]).to have_key(:id)
      expect(coupons[:data]).to have_key(:type)
      expect(coupons[:data][:type]).to eq("coupon")
      expect(coupons[:data][:attributes]).to have_key(:name)
      expect(coupons[:data][:attributes][:name]).to eq(@coupon1.name)
      expect(coupons[:data][:attributes]).to have_key(:used_count)
      expect(coupons[:data][:attributes][:used_count]).to eq(@coupon1.used_count)
    end

    it 'displays error when coupon does not exist' do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/999999999"

      expect(response.status).to eq(404)
    end
  end
end