class CouponSerializer
    include JSONAPI::Serializer
  
    attributes :id, :name, :code, :discount_type, :discount_amount, :status, :merchant_id

    attribute :usage_count do |coupon, params|
        # coupon.invoices.count  # Counts how many times this coupon has been used
        params[:usage_count] || 0 # Remember the || exists, = 0 doesn't work.
    end
end