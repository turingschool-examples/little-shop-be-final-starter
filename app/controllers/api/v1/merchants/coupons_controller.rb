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
  end