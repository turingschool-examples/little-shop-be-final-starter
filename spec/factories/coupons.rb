FactoryBot.define do
  factory :coupon do
    name { "Sample Coupon" }
    code { "CODE123" }
    active { true }
    association :merchant
  end
end