class CouponsController < ApplicationController
  def index
    @coupons = Coupon.where(merchant_id: params[:merchant_id])
    render json: @coupons
  end

  def show
    render json: @coupon
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @coupon.merchant_id = params[:merchant_id]

    if @coupon.save
      render json: @coupon, status: :created
    else
      render json: @coupon.errors, status: :unprocessable_entity
    end
  end

  def deactivate
    @coupon = Coupon.update(active: false)
    render json: @coupon
  end

  def activate
    if @coupon.merchant.coupons.where(active: true).count < 5
      @coupon = Coupon.update(active: true)
      render json: @coupon
    else
      render json: { error: "Maximum of 5 active coupons allowed." }, status: :forbidden
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :active, :merchant_id)
  end


end
