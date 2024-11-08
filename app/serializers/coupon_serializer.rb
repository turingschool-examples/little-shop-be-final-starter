class CouponSerializer
    include JSONAPI::Serializer
    attributes :code, :discount, :active, :percent_discount, :merchant_id
  end