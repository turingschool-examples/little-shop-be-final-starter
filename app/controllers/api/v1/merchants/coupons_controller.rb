class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_coupon, only: [:show, :activate, :deactivate]
  
  def index
    # require 'pry'; binding.pry
    @coupons = Coupon.where(merchant_id: params[:merchant_id])
    
    render json: CouponSerializer.new(@coupons)
  end

  def show
    render json: CouponSerializer.new(@coupons)
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @coupon.merchant_id = params[:merchant_id]

    if @coupon.save
      render json: CouponSerializer.new(@coupons), status: :created
    else
      render json: @coupon.errors, status: :unprocessable_entity
    end
  end

  def deactivate
    @coupon = Coupon.update(active: false)
    render json: CouponSerializer.new(@coupons)
  end

  def activate
    if @coupon.merchant.coupons.where(active: true).count < 5
      @coupon = Coupon.update(active: true)
      render json: CouponSerializer.new(@coupons)
    else
      render json: { error: "Maximum of 5 active coupons allowed." }, status: :forbidden
    end
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:name, :code, :active, :merchant_id)
  end
end
