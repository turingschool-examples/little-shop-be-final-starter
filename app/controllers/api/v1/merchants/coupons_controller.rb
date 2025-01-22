class Api::V1::Merchants::CouponsController < ApplicationController
    def show

        coupon = Coupon.find_by(id: params[:id], merchant_id: params[:merchant_id])

        if coupon
            render json: CouponSerializer.new(coupon), status: :ok
        else
            render json: { error: "Coupon not found" }, status: :not_found
        end
    end

    def index
        merchant = Merchant.find(params[:merchant_id])
        render json: CouponSerializer.new(merchant.coupons)
    end

    def show
        merchant = Merchant.find(params[:merchant_id]) # Ensure that merchant exists
        coupon = merchant.coupons.find(params[:id])

        render json: CouponSerializer.new(coupon,  { params: { usage_count: coupon.invoices.count } }) # got confused by this, we are looking at the num of times coupon gets used on invoice, changed serializer
    end

    def create
        merchant = Merchant.find(params[:merchant_id])
      
        # puts "Active Coupons Count: #{merchant.coupons.active.count}" # Debugging
      
        if merchant.coupons.active.count >= 5  
            render json: { error: "Merchant cannot have more than 5 active coupons" }, status: :unprocessable_entity
            return
        end
      
        coupon = merchant.coupons.new(coupon_params)
        # puts "Received Params: #{params.inspect}"  # Debugging
      
        if coupon.save
            render json: CouponSerializer.new(coupon), status: :created
        else
            # puts "Coupon Save Errors: #{coupon.errors.full_messages}"  # Debugging
            render json: { error: coupon.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

    private

    def coupon_params
        params.require(:coupon).permit(:name, :code, :discount_type, :discount_amount, :status)
    end
end