class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  attribute :coupons_count do |merchant|
    merchant.coupons.size
  end
  attribute :invoice_coupon_count do |merchant|
    merchant.invoices.where("coupon_id IS NOT NULL").count
  end
  attribute :item_count, if: Proc.new { |merchant, params|
    params && params[:count] == true
  } do |merchant|
    merchant.item_count
  end


end
