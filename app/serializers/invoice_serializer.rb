class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :customer_id, :merchant_id, :coupon_id, :status
end