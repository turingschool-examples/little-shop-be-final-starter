require 'rails_helper'

RSpec.describe "Coupons" do
  describe "GET /api/v1/merchants/:merchant_id/coupons" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:coupons) { FactoryBot.create_list(:coupon, 5, merchant: merchant) }

    it 'returns a list of coupons' do
      # require 'pry'; binding.pry
      get "/api/v1/merchants/#{merchant.id}/coupons"

# require 'pry'; binding.pry
      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response["data"].count).to eq(5)
      expect(json_response["data"].first['type']).to eq('coupon')
    end
  end
end

# require "rails_helper"

# RSpec.describe "Merchant customers endpoints" do
#   let(:merchant) { FactoryBot.create(:merchant) }
#   let(:coupons) { FactoryBot.create_list(:coupon, 5, merchant: merchant) }
  
#   it "should return all customers for a given merchant" do
    

#     get "/api/v1/merchants/#{merchant.id}/coupons"

#     json = JSON.parse(response.body, symbolize_names: true)

#     expect(response).to be_successful
#     expect(json[:data].count).to eq(2)
#     expect(json[:data][0][:id]).to eq(customer1.id.to_s)
#     expect(json[:data][0][:type]).to eq("customer")
#     expect(json[:data][0][:attributes][:first_name]).to eq(customer1.first_name)
#     expect(json[:data][0][:attributes][:last_name]).to eq(customer1.last_name)

#     expect(json[:data][1][:id]).to eq(customer2.id.to_s)
#     expect(json[:data][1][:type]).to eq("customer")
#     expect(json[:data][1][:attributes][:first_name]).to eq(customer2.first_name)
#     expect(json[:data][1][:attributes][:last_name]).to eq(customer2.last_name)
#   end

#   it "should return 404 and error message when merchant is not found" do
#     get "/api/v1/merchants/100000/customers"

#     json = JSON.parse(response.body, symbolize_names: true)

#     expect(response).to have_http_status(:not_found)
#     expect(json[:message]).to eq("Your query could not be completed")
#     expect(json[:errors]).to be_a Array
#     expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=100000")
#   end
# end