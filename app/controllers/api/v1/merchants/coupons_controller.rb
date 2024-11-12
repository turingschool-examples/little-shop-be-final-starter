class Api::V1::Merchants::CouponsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = params[:status].present? ? merchant.coupons.filter_by_status(params[:status]) : merchant.coupons
  
    render json: CouponSerializer.new(coupons), status: :ok  
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def create
    merchant = Merchant.find(params[:merchant_id])

    if params.key?(:coupon)
      coupon = merchant.coupons.new(coupon_params)
  
      if coupon.save
        render json: CouponSerializer.new(coupon), status: :created
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Invalid parameters provided'] }, status: :bad_request
    end
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    
    if coupon.update(coupon_params)
      render json: CouponSerializer.new(coupon), status: :ok
    else
      render json: { errors: ['Invalid parameters provided'] }, status: :unprocessable_entity
    end
  end

  def activate
    coupon = Coupon.find(params[:id])
    coupon.update(status: "active")
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def deactivate 
    coupon = Coupon.find(params[:id])
    coupon.update(status: "inactive")
    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_type, :discount_value, :status)
  end
end