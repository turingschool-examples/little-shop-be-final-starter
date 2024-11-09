class CouponSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :code, :discount_type, :discount_value, :status, :merchant_id

  attribute :merchant_name, if: Proc.new { | coupon, params|
    params && params[:include_merchant] == true
  } do |coupon|
    coupon.merchant.name
  end
end