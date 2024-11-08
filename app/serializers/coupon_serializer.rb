class CouponSerializer
  include JSONAPI::Serializer

  set_type :coupon
  attributes :name, :code, :discount_value, :discount_type, :active, :merchant_id, :usage_count

  attribute :merchant_name do |coupon|
    coupon.merchant.name
  end

  attribute :usage_count do |coupon|
    coupon.usage_count
  end
end
