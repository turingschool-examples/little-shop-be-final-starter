class CouponSerializer
    include JSONAPI::Serializer
  
    attributes :id, :name, :code, :discount_type, :discount_amount, :status, :merchant_id

    attribute :usage_count do |coupon|
        coupon.invoices.count  # Counts how many times this coupon has been used
    end
end