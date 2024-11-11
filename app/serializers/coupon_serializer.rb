class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :value, :active
  attribute :used_count do |coupon, params|
    params[:used_count]
  end
end