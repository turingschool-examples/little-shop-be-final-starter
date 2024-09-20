FactoryBot.define do
  factory :coupon do
    name { "MyString" }
    code { "MyString" }
    discount_value { "9.99" }
    active { false }
    merchant 
  end
end
