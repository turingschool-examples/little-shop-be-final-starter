FactoryBot.define do
  factory :item do
    name { "Test Item" }
    description { "A great item" }
    unit_price { 9.99 }
    association :merchant
  end
end