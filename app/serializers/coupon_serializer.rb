class CouponSerializer
  include JSONAPI::Serializer
  
  set_type :coupon
  
  attributes :name, :code, :active
end
