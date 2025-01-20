 FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    customer
    merchant

    trait :with_coupon do
      association :coupon, active: true
    end
  end
end