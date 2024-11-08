class Api::V1::Merchants::CouponsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    merchant = Merchant.find_by(id: params[:merchant_id])
    return render json: ErrorSerializer.format_errors(['Merchant not found']), status: :not_found unless merchant

    coupon = merchant.coupons.find_by(id: params[:id])
    return render json: ErrorSerializer.format_errors(['Coupon not found']), status: :not_found unless coupon

    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def record_not_found
    render json: ErrorSerializer.format_errors(['Your query could not be completed']), status: :not_found
  end
end