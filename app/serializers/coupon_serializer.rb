class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :dollar_off, :percent_off, :status, :merchant_id
end
