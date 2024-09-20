class CouponSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :code, :discount_value, :active, :merchant_id
end
