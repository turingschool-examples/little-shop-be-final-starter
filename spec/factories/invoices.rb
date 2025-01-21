FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    merchant
    customer
    coupon { association :coupon }  # Ensure a valid coupon exists
  end
end