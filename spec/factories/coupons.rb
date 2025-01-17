FactoryBot.define do
  factory :coupon do
    name { "Coupon Name" }
    code { "Coupon Code" }
    dollar_off { 1.0 }
    percent_off { 10 }
    status { "active"}
    merchant
  end
end