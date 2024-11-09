FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    customer
    merchant

    trait :with_coupon do
      association :coupon, factory: :coupon
    end

    trait :without_coupon do
      coupon_id { nil }
    end
  end
end