FactoryBot.define do
    factory :coupon do
      name { "Coupon Name" }  
      code { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
      percent_off { Faker::Number.between(from: 5, to: 50) }
      dollar_off { nil }  
      used_count { 0 }  
  
      association :merchant

    end
  end
  