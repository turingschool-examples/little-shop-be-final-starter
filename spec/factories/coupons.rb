FactoryBot.define do
  factory :coupon do
    name { "Discount Code"}
    code { Faker::Alphanumeric.unique.alphanumeric(number: 10).upcase }
    discount_value { Faker::Number.between(from: 5.0, to: 50.0)}
    discount_type { ["percent", "dollar"].sample}
    active { true }
    association :merchant
  end
end