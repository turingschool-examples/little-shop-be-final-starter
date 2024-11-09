FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "Coupon #{n}" }
    sequence(:code) { |n| "CODE#{n}" }
    discount_type { %w[percent_off dollar_off].sample }
    discount_value { rand(1.0..40.0)}
    status { true }
    association :merchant

    trait :active do
      status { true }
    end

    trait :inactive do
      status { false }
    end

    trait :percent_off do
      discount_type { 'percent_off' }
      discount_value { rand(5.0..40.0) }
    end

    trait :dollar_off do
      discount_type { 'dollar_off' }
      discount_value { rand(1.0..50.0) }
    end
  end
end