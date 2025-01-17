class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :code, :percent_off, :dollar_off, :merchant_id, :status
end