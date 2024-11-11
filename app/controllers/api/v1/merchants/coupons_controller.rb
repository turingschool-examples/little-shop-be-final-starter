class Api::V1::Merchants::CouponsController < ApplicationController 

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.format_errors(["Coupon not found"]), status: :not_found
  end
end