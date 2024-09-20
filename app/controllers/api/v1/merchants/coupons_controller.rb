class Api::V1::Merchants::CouponsController < ApplicationController

  def show 
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end
end
