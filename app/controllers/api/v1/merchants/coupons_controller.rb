class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_merchant # will set up merchant with id before each of these
  
  def index
    coupons = @merchant.coupons

    if coupons.empty?
      render json: ErrorSerializer.format_errors(["No coupons found for this merchant"]), status: :not_found
    else
      render json: CouponSerializer.new(coupons), status: :ok
    end
  end

  def show
    coupon = @merchant.coupons.find(params[:id])

    if coupon
      render json: CouponSerializer.new(coupon), status: :ok
    else
      render json: ErrorSerializer.format_errors(["Coupon not found"]), status: :not_found
    end
  end

  def create
    coupon = @merchant.coupons.new(coupon_params)

    if coupon.save
      render json: {
        message: "Coupon saved successfully!",
        coupon: CouponSerializer.new(coupon)
      }, status: :created
    else
      render json: ErrorSerializer.format_errors(["Coupon not created"]), status: :unprocessable_entity
    end
  end

  private
  def set_merchant
    @merchant = Merchant.find_by(id: params[:merchant_id])
    render json: ErrorSerializer.format_errors(["Merchant not found"])unless @merchant
  end
  
  def coupon_params
    params.require(:coupon).permit(:name, :code, :percent_off, :dollar_off)
  end

end