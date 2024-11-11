class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :merchant_id, :customer_id, :status, :coupon_id
end