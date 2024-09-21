class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_coupon, only: [:activate, :deactivate]
  
  def index
    @coupons = Coupon.for_merchant(params[:merchant_id])
    render json: CouponSerializer.new(@coupons)
  end

  def show
    @coupons = Coupon.find_by(id: params[:id], merchant_id: params[:merchant_id])
    render json: CouponSerializer.new(@coupons)
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @coupon.merchant_id = params[:merchant_id]

    if @coupon.save
      render json: CouponSerializer.new(@coupon), status: :created
    else
      render json: @coupon.errors, status: :unprocessable_entity
    end
  end

  def deactivate
    @coupon.update(active: false)
    render json: CouponSerializer.new(@coupon)
  end

  def activate
    if @coupon.activate_coupon
      render json: CouponSerializer.new(@coupon)
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
