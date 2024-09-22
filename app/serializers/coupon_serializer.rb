class CouponSerializer
  include JSONAPI::Serializer
  
  set_type :coupon
  
  attributes :name, :code, :active, :discount_type, :discount_value
end
