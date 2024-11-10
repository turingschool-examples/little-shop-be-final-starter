FactoryBot.define do
  factory :coupon do
    name { Faker::Commerce.promotion_code }
    code { Faker::Alphanumeric.unique.alphanumeric(number: 10).upcase }
    discount_value { Faker::Number.between(from: 5.0, to: 50.0).round(2)}
    discount_type { ["percent", "dollar"].sample}
    active { false }
    association :merchant
  end
end