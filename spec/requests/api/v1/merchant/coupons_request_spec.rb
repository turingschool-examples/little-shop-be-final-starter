# bundle exec rspec spec/requests/api/v1/merchant/coupons_request_spec.rb
require "rails_helper"

RSpec.describe "Merchant Coupon endpoints" do
  before :each do
    @merchant1 = create(:merchant)
    @coupon1 = create(:coupon, merchant: @merchant1)
    
    @merchant2 = create(:merchant)
    @coupon2 = create(:coupon, merchant: @merchant2)
    @coupon3 = create(:coupon, merchant: @merchant2)
  end

  describe "Merchant Coupons Index" do 
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

  describe "Merchant Coupon Create" do
    it "creates a new coupon for a merchant" do
      new_coupon_params = { name: "Employee discount", code: "EMPL25", percent_off: 25}
      headers = { "CONTENT_TYPE" => "application/json" }
      # We include this header to make sure that these params are passed as JSON rather than as plain text

      post "/api/v1/merchants/#{@merchant1.id}/coupons/", headers: headers, params: JSON.generate(coupon: new_coupon_params)

      expect(response).to be_successful

      created_coupon = Coupon.last

      expect(created_coupon.name).to eq(new_coupon_params[:name])
      expect(created_coupon.code).to eq(new_coupon_params[:code])
      expect(created_coupon.percent_off).to eq(new_coupon_params[:percent_off])
    end
  end

end