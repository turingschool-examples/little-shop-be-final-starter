FactoryBot.define do
  factory :coupon_use do
    coupon { create(:coupon) }
    customer { create(:customer) }
  end
end
