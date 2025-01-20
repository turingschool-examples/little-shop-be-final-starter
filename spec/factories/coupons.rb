FactoryBot.define do
  factory :coupon do
    association :merchant
    full_name { "Discount Coupon" }
    sequence(:code) { |n| "CODE#{n}" }
    active { true }
    usage_count { 0 } 

    percent_off { 10.0 }
    dollar_off { nil }

    trait :dollar_discount do
      percent_off { nil }
      dollar_off { 20.0 }
    end

    trait :inactive do
      active { false }
    end
  end
end
