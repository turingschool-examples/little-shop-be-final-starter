FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    customer
    merchant
    coupon {nil}

    trait :with_coupon do
      association :coupon
    end
  end
end