class Api::V1::CouponsController < ApplicationController
  def show
    coupon = Coupon.find(params[:id])
    meta_data = {}
    meta_data[:meta] = { usage_count: Coupon.invoice_coupon_count(coupon) }
    render json: CouponSerializer.new(coupon, meta_data), status: :ok
  end
end