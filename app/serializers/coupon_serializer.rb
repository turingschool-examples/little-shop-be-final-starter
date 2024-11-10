class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :value, :active
end