class Api::V1::Merchants::CouponsController < ApplicationController 
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons)
  end
  
  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end


  def record_not_found(exception)
    render json: ErrorSerializer.format_record_not_found(exception.model), status: :not_found
  end
end