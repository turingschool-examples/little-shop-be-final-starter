class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons), status: :ok
  end

  def show
    coupon = Coupon.find_by_merchant_and_id(params[:merchant_id], params[:id])
    
    if coupon
      render json: CouponSerializer.new(coupon), status: :ok
    else
      record_not_found
    end
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(coupon_params)

    if coupon.save
      render json: CouponSerializer.new(coupon), status: :created
    else
      render json: ErrorSerializer.format_validation_errors(coupon), status: :unprocessable_entity
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_value, :discount_type, :active)
  end

  def record_not_found
    render json: ErrorSerializer.format_errors(['Your query could not be completed']), status: :not_found
  end
end