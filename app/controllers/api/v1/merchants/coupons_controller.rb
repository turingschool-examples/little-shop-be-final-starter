class Api::V1::Merchants::CouponsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  private

  def record_not_found
    render json: ErrorSerializer.format_errors(['Resource not found']), status: :not_found
  end
end