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

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(json[:data].count).to eq(1)
    expect(json[:data][0][:id]).to eq(@coupon1.id.to_s)
    expect(json[:data][0][:type]).to eq("coupon")
    expect(json[:data][0][:attributes][:name]).to eq(@coupon1.name)
    expect(json[:data][0][:attributes][:code]).to eq(@coupon1.code)
    expect(json[:data][0][:attributes][:percent_off]).to eq(@coupon1.percent_off.to_s)
    expect(json[:data][0][:attributes][:dollar_off]).to eq(@coupon1.dollar_off)
  end

end