class Api::V1::Merchants::CouponsController < ApplicationController
  
  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons

    #  render json: coupons.map { |coupon| 
    #   {
    #   id: coupon.id,
    #   type: "coupon",
    #   attributes: {
    #     name: coupon.full_name,
    #     code: coupon.code,
    #     percent_off: coupon.percent_off,
    #     dollar_off: coupon.dollar_off,
    #     active: coupon.active,
    #     merchant_id: coupon.merchant_id,
    #     usage_count: coupon.usage_count
    #     }
    #   }
    # }, status: :ok
    render json: CouponSerializer.new(coupons)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Coupon not found' }, status: :not_found
  end

  def create 
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(coupon_params)

    if coupon.save
      render json: CouponSerializer.new(coupon), status: :created
    else
      render json: { error: coupon.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def activate 
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])

    if coupon.active
      render json: { message: "Coupon is already active."}, status: :unprocessable_entity
    elsif coupon.update(active: true)
      render json: CouponSerializer.new(coupon), status: :ok
    end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Coupon not found" }, status: :not_found
  end
  

  def show
    begin
      merchant = Merchant.find(params[:merchant_id])
      coupon = merchant.coupons.find(params[:id])

      usage_count = coupon.invoices.count 

      render json: CouponSerializer.new(coupon), status: :ok 
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Coupon not found' }, status: :not_found
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:full_name, :code, :percent_off, :dollar_off, :active)
  end

end

