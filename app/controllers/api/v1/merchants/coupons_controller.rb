class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_merchant 

  def index
    coupons = @merchant.coupons

    # Moved status validation logic into a method
    if params[:status].present?
      status_validation_result = validate_status(params[:status])
      return render json: status_validation_result[:errors], status: status_validation_result[:status] if status_validation_result[:errors]
      
      coupons = coupons.where(status: params[:status])
    end

    if coupons.empty?
      return render json: ErrorSerializer.format_errors(["No coupons found for this merchant"]), status: :not_found
    end

    render json: CouponSerializer.new(coupons), status: :ok
  end

  def show
    coupon = @merchant.coupons.find_by(id: params[:id])

    if coupon
      render json: CouponSerializer.new(coupon), status: :ok
    else
      render json: ErrorSerializer.format_invalid_search_response, status: :not_found
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
      render json: ErrorSerializer.format_validation_errors(coupon), status: :unprocessable_entity
    end
  end

  def activate
    coupon = Coupon.find_by(id: params[:id])
    if coupon.nil?
      return render json: ErrorSerializer.format_invalid_search_response, status: :not_found
    end

    # Moved active coupon count check to merchant model 
    if @merchant.active_coupons_count >= 5
      return render json: { error: 'A merchant can only have up to 5 active coupons at a time' }, status: :unprocessable_entity
    end

    coupon.activate!
    
    render json: { message: "Coupon activated successfully!", status: :ok }
  end

  def deactivate
    coupon = Coupon.find_by(id: params[:id])
  
    if coupon.nil?
      return render json: ErrorSerializer.format_invalid_search_response, status: :not_found
    end

    coupon.deactivate!

    render json: { message: "Coupon deactivated successfully.", status: :ok }
  end

  private

  def set_merchant
    @merchant = Merchant.find_by(id: params[:merchant_id])
    render json: ErrorSerializer.format_errors(["Merchant not found"]), status: :not_found unless @merchant
  end

  def coupon_params
    params.require(:coupon).permit(:name, :code, :percent_off, :dollar_off)
  end

  # New helper method to validate the status
  def validate_status(status)
    valid_statuses = ["active", "inactive"]
    if valid_statuses.include?(status)
      return { errors: nil, status: nil }
    else
      return { errors: ErrorSerializer.format_errors(["Invalid coupon status"]), status: :bad_request }
    end
  end
end
