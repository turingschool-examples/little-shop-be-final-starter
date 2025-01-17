class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :dollar_off, :percent_off, :status, :merchant_id

  attribute :usage_count do |coupon|
    Coupon.invoice_coupon_count(coupon)
  end
end
