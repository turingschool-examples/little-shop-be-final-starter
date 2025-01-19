class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_merchant # will set up merchant with id before each of these
  
  def index
    coupons = @merchant.coupons

    if params[:status].present?
      coupons = coupons.where(status: params[:status])
    end

    if coupons.empty?
      render json: ErrorSerializer.format_errors(["No coupons found for this merchant"]), status: :not_found
    else
      render json: CouponSerializer.new(coupons), status: :ok
    end
  end

  def show
    coupon = @merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.format_invalid_search_response, status: :not_found
  end


  def create
    coupon = @merchant.coupons.new(coupon_params)

    if coupon.save
      render json: {
        message: "Coupon saved successfully!",
        coupon: CouponSerializer.new(coupon)
      }, status: :created
    else
      render json: ErrorSerializer.format_validation_errors(coupon), status: :unprocessable_entity
    end
  end

  def activate
    coupon = Coupon.find_by(id: params[:id])
  
    if coupon.nil?
      render json: { error: 'Coupon not found' }, status: :not_found
    else
      coupon.activate!
      render json: {
        message: "Coupon activated successfully!",
        status: :ok
      }
    end
  end

  def deactivate
    coupon = Coupon.find_by(id: params[:id])
  
    if coupon.nil?
      render json: { error: 'Coupon not found' }, status: :not_found
    else
      coupon.deactivate!
      render json: {
        message: "Coupon deactivated successfully.",
        status: :ok
      }
    end
  end


  private
  def set_merchant
    @merchant = Merchant.find_by(id: params[:merchant_id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.format_errors(["Merchant not found"])unless @merchant
  end
  
  def coupon_params
    params.require(:coupon).permit(:name, :code, :percent_off, :dollar_off)
  end

end