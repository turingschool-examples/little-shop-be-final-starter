FactoryBot.define do
    factory :coupon do
        name { Faker::Commerce.product_name + " Discount" }
        code { Faker::Commerce.promotion_code }
        percent_off { nil }
        dollar_off { Faker::Number.between(from: 5, to: 25).to_f.round(2) }
        status { "active" }
        merchant
    end
end