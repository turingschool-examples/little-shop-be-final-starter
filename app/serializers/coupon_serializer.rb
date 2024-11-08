class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :discount, :active, :percent_discount, :merchant_id
  end