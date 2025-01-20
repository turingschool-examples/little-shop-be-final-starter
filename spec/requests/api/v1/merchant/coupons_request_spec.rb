require "rails_helper"

RSpec.describe "Merchant Coupons API", type: :request do
  
  describe "GET /api/v1/merchants/:merchant_id/coupons" do
    it "returns all of a merchant's coupons" do
      merchant = create(:merchant)
      coupon1 = create(:coupon, merchant: merchant, full_name: "Spring Sale", code: "SPRING10")
      coupon2 = create(:coupon, merchant: merchant, full_name: "A Spring Sale", code: "SPRING11")
      coupon3 = create(:coupon, merchant: merchant, full_name: "The Spring Sale", code: "SPRING12")

      get "/api/v1/merchants/#{merchant.id}/coupons"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes][:full_name]).to eq(coupon1.full_name)
      expect(json[:data][0][:id]).to eq(coupon1.id.to_s)
      expect(json[:data][1][:id]).to eq(coupon2.id.to_s)
      expect(json[:data][2][:id]).to eq(coupon3.id.to_s)
    end
  end

  describe "POST /api/v1/merchants/:merchant_id/coupons" do
    it "should create a coupon when all fields are provided" do
      merchant = create(:merchant)
      coupon_attributes = attributes_for(:coupon, full_name: "Spring Sale", code: "SPRING10")

      post "/api/v1/merchants/#{merchant.id}/coupons", params: { coupon: coupon_attributes }
  
      json = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes][:full_name]).to eq("Spring Sale")
      expect(json[:data][:attributes][:code]).to eq("SPRING10")
    end
  end
  
  
  describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
    it "returns merchant's coupon by coupon id" do
      merchant = create(:merchant)
      coupon = create(:coupon, merchant: merchant, full_name: "Spring Sale", code: "SPRING10")

      get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data][:id]).to eq(coupon.id.to_s)
      expect(json[:data][:type]).to eq("coupon")
      expect(json[:data][:attributes][:full_name]).to eq("Spring Sale")
      expect(json[:data][:attributes][:code]).to eq("SPRING10")
      expect(json[:data][:attributes][:merchant_id]).to eq(merchant.id)
      expect(json[:data][:attributes][:usage_count]).to eq(coupon.invoices.count)
    end
  

    it "returns a 404 error if the coupon does not exist for the given merchant" do
      merchant = create(:merchant)
        
      get "/api/v1/merchants/#{merchant.id}/coupons/99999"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:error]).to eq("Coupon not found")
    end

    it "returns a 404 error if the merchant does not exist" do
      get "/api/v1/merchants/99999/coupons/1" 
      json = JSON.parse(response.body, symbolize_names: true) 
      
      expect(response).to have_http_status(:not_found) 
      expect(json[:error]).to eq("Coupon not found")
    end

    # it 'includes the correct usage_count' do
    #   merchant = create(:merchant)
    #   coupon = create(:coupon)
  
    #   create(:invoice, coupon: coupon, customer_name: 'John Doe', total: 100)
    #   create(:invoice, coupon: coupon, customer_name: 'Jane Smith', total: 200)
    #   create(:invoice, coupon: coupon, customer_name: 'Alice Johnson', total: 300)
  
    #   serialized = CouponSerializer.new(coupon).serializable_hash
  
    #   attributes = serialized[:data][:attributes]
  
    #   expect(attributes[:usage_count]).to eq(3)
    # end 
  end
  
end