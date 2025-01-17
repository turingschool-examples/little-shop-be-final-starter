# bundle exec rspec spec/requests/api/v1/merchant/coupons_request_spec.rb
require "rails_helper"

RSpec.describe "Merchant Coupon endpoints" do
  before :each do
    @merchant1 = Merchant.create!(name: "Merchant Name")
    @coupon1 = Coupon.create!(merchant: @merchant1, name: "Buy One Get One 50", code: "BOGO50", percent_off: 50)
    
    @merchant2 = Merchant.create!(name: "That Guy")
    @coupon2 = Coupon.create!(merchant: @merchant2, name: "10 Percent Off", code: "10PER", percent_off: 10)
    @coupon3 = Coupon.create!(merchant: @merchant2, name: "5 Off Ten or More", code: "5OFF", dollar_off: 5)
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
  end

  describe 'GET /api/v1/merchants/:merchant_id/coupons/:id' do
    let!(:merchant) { create(:merchant) }  # Create a merchant
    let!(:coupon) { create(:coupon, merchant: merchant, name: "Buy One Get One 50") }  # Create a coupon
    let!(:usage_count) { 5 }  # Set the number of times this coupon has been used
  
    before do
      # Assuming you have a way to track coupon usage, for example, a counter_cache or a `use` method
      coupon.update(used_count: usage_count)  # Set the coupon's usage count (if it exists)
    end
  
    it 'returns a specific coupon and shows how many times it has been used' do
      # Make the GET request to the show endpoint
      get api_v1_merchant_coupon_path(merchant_id: merchant.id, id: coupon.id)
  
      # Check that the response was successful (status 200)
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      # Parse the JSON response
      json_response = JSON.parse(response.body)
  
      # Validate the response structure and ensure it contains the expected data
      expect(json_response['data']).to have_key('id')
      expect(json_response['data']['type']).to eq('coupon')
      expect(json_response['data']['attributes']).to have_key('name')
      expect(json_response['data']['attributes']['name']).to eq(coupon.name)
      expect(json_response['data']['attributes']).to have_key('used_count')
      expect(json_response['data']['attributes']['used_count']).to eq(usage_count)
    end
  end
  


end