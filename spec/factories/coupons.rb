FactoryBot.define do
    factory :coupon do
        name { "Buy One Get One 50% off" }
        code { "BOGO50" }
        discount_type { "percent_off" }
        discount_amount { 50 }
        status { "active" }
        association :merchant
    end
end

# error Failures:

#   1) Merchant Coupons Show GET /api/v1/merchants/:merchant_id/coupons/:id returns merchant coupons for specified merchant
#   Failure/Error: coupon = create(:coupon, merchant: merchant)
  
#   KeyError:
#     Factory not registered: "coupon"

# Reason was as stated, no factorybot for coupons