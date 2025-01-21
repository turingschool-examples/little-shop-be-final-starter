# bundle exec rspec spec/requests/api/v1/merchant/coupons_request_spec.rb
require "rails_helper"

RSpec.describe "Merchant Coupon endpoints" do
  before :each do
    @merchant1 = create(:merchant)
    @coupon1 = create(:coupon, merchant: @merchant1)
    
    @merchant2 = create(:merchant)
    @coupon2 = create(:coupon, merchant: @merchant2)
    @coupon3 = create(:coupon, merchant: @merchant2)

    @merchant3 = create(:merchant)
  end
  
  context 'when the merchant_id provided does not exist' do
    it 'returns a not_found error' do
      invalid_merchant_id = 999999
      get api_v1_merchant_coupons_path(invalid_merchant_id)
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('Merchant not found')
    end
  end
  
  describe "#INDEX" do 
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
      expect(coupons[:data][0][:attributes][:status]).to eq(@coupon1.status)
    end

    it "returns a not found status when there are no coupons for the merchant" do
      get "/api/v1/merchants/#{@merchant3.id}/coupons"

      coupons = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)

      expected_error = {
        "errors" => ["No coupons found for this merchant"],
        "message" => "Your query could not be completed"
      }
      
      expect(JSON.parse(response.body)).to eq(expected_error)
    end

    context "when filtering by status" do
      it "returns only active coupons when status=active" do
        get api_v1_merchant_coupons_path(@merchant2.id, status: 'active')

        expect(response).to be_successful
        
        json = JSON.parse(response.body)
        
        expect(json['data'].length).to eq(2)
        expect(json['data'][0]['attributes']['status']).to eq('active')
      end

      it "returns only inactive coupons when status=inactive" do
        coupon4 = create(:coupon, merchant: @merchant3, status: 'active')
        coupon5 = create(:coupon, merchant: @merchant3, status: 'active')
        coupon5 = create(:coupon, merchant: @merchant3, status: 'inactive')

        get api_v1_merchant_coupons_path(@merchant3.id, status: 'inactive')
        
        expect(response).to be_successful
        
        json = JSON.parse(response.body)
        
        expect(json['data'].length).to eq(1)
        expect(json['data'][0]['attributes']['status']).to eq('inactive')
      end

      it "if an invalid status is provided it returns no coupons" do
        get "/api/v1/merchants/#{@merchant1.id}/coupons?status=nonexistentstatus"
        
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:errors]).to include("Invalid coupon status")
      end
    end
  end

  describe "#SHOW" do
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
      expect(coupons[:data][:attributes][:status]).to eq(@coupon1.status)
    end

    it 'displays error when coupon does not exist' do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/999999999"

      expect(response.status).to eq(404)

      expected_error = {
        "errors"=>["Invalid search parameters provided"], 
        "message"=>"Coupon not found"
      }
      
      expect(JSON.parse(response.body)).to eq(expected_error)
    end
  end

  describe "#CREATE" do
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

    it 'displays error when coupon created does not provide required params' do
      new_coupon_params = { coupon: { name: '', code: '', percent_off: nil, dollar_off: nil } }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/merchants/#{@merchant1.id}/coupons/", headers: headers, params: JSON.generate(coupon: new_coupon_params)

      expect(response.status).to eq(422)

      expected_error = {
        "message" => "Coupon could not be created",
        "errors" => ["Name can't be blank", "Code can't be blank", "You must provide either percent_off or dollar_off."],      }

      expect(JSON.parse(response.body)).to eq(expected_error)
    end

    it 'displays error when coupon code already exists' do
      coupon4 = create(:coupon, merchant: @merchant1, name: "Spring Sale", code: "SPRING2025", percent_off: 10)

      new_coupon_params = {
        coupon: {
          name: "Summer Sale",
          code: "SPRING2025",  # Same code as coupon1
          percent_off: 20
        }
      }
      
      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_merchant_coupons_path(@merchant1), headers: headers, params: JSON.generate(new_coupon_params)
    
      expect(response.status).to eq(422)
    
      expected_error = {
        "message" => "Coupon could not be created",
        "errors" => ["Code has already been taken"]
      }

      expect(JSON.parse(response.body)).to eq(expected_error)
    end


  end

  describe "#PATCH deactivate" do
    context 'when the coupon exists' do
      it "updates status to inactive" do
        patch deactivate_api_v1_merchant_coupon_path(@merchant1, id: @coupon1.id)

        expect(response).to be_successful
        json = JSON.parse(response.body)

        expect(json['message']).to eq("Coupon deactivated successfully.")

        @coupon1.reload
        expect(@coupon1.status).to eq("inactive")
      end
    end

    context 'when coupon does not exist' do
      it 'returns a not found error' do
        patch deactivate_api_v1_merchant_coupon_path(@merchant1, id: 999999)
        
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)

        expect(json['message']).to eq('Coupon not found')
      end
    end
  end

  describe "#PATCH activate" do
    context 'when the coupon exists' do
      it "updates status to active" do
        patch activate_api_v1_merchant_coupon_path(@merchant1, id: @coupon1.id)

        expect(response).to be_successful
        json = JSON.parse(response.body)

        expect(json['message']).to eq("Coupon activated successfully!")

        @coupon1.reload
        expect(@coupon1.status).to eq("active")
      end
    end

    context 'when coupon does not exist' do
      it 'returns a not found error' do
        patch activate_api_v1_merchant_coupon_path(@merchant1, id: 999999)
        
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)

        expect(json['message']).to eq('Coupon not found')
      end
    end

    context 'when the merchant already has 5 coupons' do
      before do
        5.times do
          create(:coupon, merchant: @merchant3, status: 'active')
        end
      end

      it 'does not allow a 6th active coupon and returns an error' do
        coupon_to_activate = create(:coupon, merchant: @merchant3, status: 'pending')

        patch activate_api_v1_merchant_coupon_path(@merchant3, id: coupon_to_activate.id)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json['error']).to eq('A merchant can only have up to 5 active coupons at a time')
      end
    end
  end
end