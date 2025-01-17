class Api::V1::CouponsController < ApplicationController
  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def item_params
    params.permit(:name, :code, :dollar_off, :percent_off, :status, :merchant_id)
  end
end