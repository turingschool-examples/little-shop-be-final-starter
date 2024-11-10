class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    coupons = Coupon.by_merchant(params[:merchant_id])
    if coupons.present?
      render json: CouponSerializer.new(coupons), status: :ok
    else
      record_not_found
    end
  end

  def show
    coupon = Coupon.find_by_merchant_and_id(params[:merchant_id], params[:id])
    return record_not_found unless coupon

    render json: CouponSerializer.new(coupon), status: :ok
  end

  def create
    coupon = Coupon.create_for_merchant(params[:merchant_id], coupon_params)
    if coupon&.persisted?
      render json: CouponSerializer.new(coupon), status: :created
    else
      render json: ErrorSerializer.format_errors(coupon&.errors&.full_messages || ['Invalid parameters']), status: :unprocessable_entity
    end
  end

  def update
    coupon = Coupon.find_by_merchant_and_id(params[:merchant_id], params[:id])
    return record_not_found unless coupon
  
    coupon.update(coupon_params)
    render json: CouponSerializer.new(coupon), status: :ok
  end
  

  private
  
  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_value, :discount_type, :active)
  end
  

  def record_not_found
    render json: ErrorSerializer.format_errors(['Your query could not be completed']), status: :not_found
  end
end
