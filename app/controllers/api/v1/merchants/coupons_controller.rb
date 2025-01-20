class Api::V1::Merchants::CouponsController < ApplicationController
  def show
    begin
      merchant = Merchant.find(params[:merchant_id])
      coupon = merchant.coupons.find(params[:id])

      # usage_count = coupon.invoices.count 
      render json: {
        data: {
          id: coupon.id,
          type: "coupon",
          attributes: {
            name: coupon.full_name,
            code: coupon.code,
            percent_off: coupon.percent_off,
            dollar_off: coupon.dollar_off,
            active: coupon.active,
            merchant_id: coupon.merchant_id
            # usage_count: usage_count
          }
        }
      }
      # render json: CouponSerializer.new(coupon), status: :ok 
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Coupon not found' }, status: not_found
    end
  end
end
