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
end