class Api::V1::Merchants::CouponsController < ApplicationController
    def index
      merchant = Merchant.find(params[:merchant_id])
      coupons = merchant.coupons

      if coupons.empty?
        render json: { message: 'No coupons found for this merchant' }, status: :not_found
      else
        render json: CouponSerializer.new(coupons), status: :ok
      end
    end

    def show
      merchant = Merchant.find(params[:merchant_id])
      coupon = merchant.coupons.find(params[:id])

      render json: {
        data: {
          id: coupon.id.to_s,
          type: 'coupon',
          attributes: {
            name: coupon.name,
            used_count: coupon.used_count  # Either the counter attribute or count of uses
          }
        }
      }, status: :ok
    end

  end