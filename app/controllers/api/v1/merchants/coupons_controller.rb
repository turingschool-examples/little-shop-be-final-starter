class Api::V1::Merchants::CouponsController < ApplicationController
  def show
    coupon = Coupon.find_by(id: params[:id])
    render json: CouponSerializer.new(coupon)
  end
end