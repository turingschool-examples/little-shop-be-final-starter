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

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(coupon_params)
    if coupon.save 
      render json: CouponSerializer.new(coupon), status: :created 
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_value, :active)
  end
end
