class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :merchant_id, :customer_id, :coupon_id, :status
end