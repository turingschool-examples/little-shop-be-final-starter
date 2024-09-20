class Api::V1::Merchants::CouponsController < ApplicationController

  def show 
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons)
  end
end
