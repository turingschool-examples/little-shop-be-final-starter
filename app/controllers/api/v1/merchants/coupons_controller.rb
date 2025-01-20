class Api::V1::Merchants::CouponsController < ApplicationController
    def show

        coupon = Coupon.find_by(id: params[:id], merchant_id: params[:merchant_id])

        if coupon
            render json: CouponSerializer.new(coupon), status: :ok
        else
            render json: { error: "Coupon not found" }, status: :not_found
        end
    end
end