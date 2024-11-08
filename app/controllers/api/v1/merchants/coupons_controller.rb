class Api::V1::Merchants::CouponsController < ApplicationController
    def show
        coupon = Coupon.find(params[:id])
        render json: CouponSerializer.new(item), status: :ok  
    end

    def create
        coupon = Coupon.create!(coupon_params)
        render json: CouponSerializer.new(item), status: :created
    end

    private

    def coupon_params
      params.permit(:code, :discount, :active, :percent_discount, :merchant_id)
    end
end