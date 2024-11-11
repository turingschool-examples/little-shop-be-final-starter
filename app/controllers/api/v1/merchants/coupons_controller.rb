class Api::V1::Merchants::CouponsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = if params[:status].present?
                merchant.coupons.filter_by_status(params[:status])
              else
                merchant.coupons
              end
              
    render json: CouponSerializer.new(coupons), status: :ok
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(coupon_params)
    render json: CouponSerializer.new(coupon), status: :created
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    coupon.update(coupon_params)
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def activate
    coupon = Merchant.find(params[:merchant_id]).coupons.find(params[:id])
    coupon.update(status: true)
    render json: CouponSerializer.new(coupon)
  end

  def deactivate 
    coupon = Merchant.find(params[:merchant_id]).coupons.find(params[:id])
    coupon.update(status: false)
    render json: CouponSerializer.new(coupon)
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_type, :discount_value, :status)
  end
end