class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :ccode, :percent_off, :dollar_off
end