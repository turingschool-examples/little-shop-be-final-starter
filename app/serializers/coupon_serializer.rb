class CouponSerializer
  include JSONAPI::Serializer
  attributes :full_name, :code, :percent_off, :dollar_off, :active,  :merchant_id 

  attribute :usage_count do |coupon|
    coupon.invoices.count
  end
end