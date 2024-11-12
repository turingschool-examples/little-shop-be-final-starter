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
    render json: CouponSerializer.new(coupon, { params: {used_count: coupon.used_count }})
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(coupon_params)

    if coupon.save 
      render json: CouponSerializer.new(coupon), status: :created
    else
      render json: ErrorSerializer.format_errors(coupon.errors.full_messages), status: :bad_request
    end
  end

  def update
    coupon = Coupon.find(params[:id])
    merchant = coupon.merchant
    new_status = params[:active] == 'true'
    if coupon.update_status(new_status)
      render json: CouponSerializer.new(coupon), status: :ok
    else
      render json: { errors: coupon.errors.full_messages }, status: :bad_request
    end

  end


  private

  def coupon_params
    params.permit(:name, :code, :value, :active)
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_record_not_found(exception.model), status: :not_found
  end
end