class Api::V1::Merchants::CouponsController < ApplicationController
    
    def index
        merchant = Merchant.find(params[:merchant_id])
        render json: CouponSerializer.new(merchant.coupons)
      end



    def show
        coupon = Coupon.find(params[:id])
        render json: CouponSerializer.new(coupon), status: :ok  
    end

    def create
        coupon = Coupon.create!(coupon_params)
        render json: CouponSerializer.new(coupon), status: :created
    end

    private

    def coupon_params
      params.permit(:code, :discount, :active, :percent_discount, :merchant_id)
    end
end