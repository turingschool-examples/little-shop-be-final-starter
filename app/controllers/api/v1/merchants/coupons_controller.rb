class Api::V1::Merchants::CouponsController < ApplicationController
    
    def index
        merchant = Merchant.find(params[:merchant_id])
        if params[:active].present?
            coupons = merchant.coupons_filtered_by_active(params[:active])
        else
            coupons = merchant.coupons
        end
        render json: CouponSerializer.new(coupons)
      end



    def show
        coupon = Coupon.find(params[:id])
        render json: CouponSerializer.new(coupon), status: :ok  
    end

    def create
        coupon = Coupon.create!(coupon_params)
        render json: CouponSerializer.new(coupon), status: :created
    end

    def activate
        coupon = Coupon.find(params[:id])
        coupon.update!(active: true)
        render json: CouponSerializer.new(coupon)
    end

    def deactivate
        coupon = Coupon.find(params[:id])
        coupon.update!(active: false)
        render json: CouponSerializer.new(coupon)
    end

    private

    def coupon_params
      params.permit(:code, :discount, :active, :percent_discount, :merchant_id)
    end
end