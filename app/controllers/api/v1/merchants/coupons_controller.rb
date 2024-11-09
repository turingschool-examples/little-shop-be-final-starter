class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    merchant = Merchant.find_by(id: params[:merchant_id])
    if merchant.nil?
      render json: ErrorSerializer.format_errors(['Your query could not be completed']), status: :not_found
      return
    end

    coupon = merchant.coupons.find_by(id: params[:id])
    if coupon.nil?
      render json: ErrorSerializer.format_errors(['Your query could not be completed']), status: :not_found
      return
    end

    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def record_not_found
    render json: ErrorSerializer.format_errors(['Your query could not be completed']), status: :not_found
  end
end
