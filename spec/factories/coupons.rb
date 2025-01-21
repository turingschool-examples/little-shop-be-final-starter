FactoryBot.define do
    factory :coupon do
      sequence(:name) { |n| "Discount #{n}" }
      sequence(:code) { |n| "CODE#{n}" }  # Ensures unique codes
      discount_type { "percent_off" }
      discount_amount { 10 }
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

# ☠️  [little-shop-be-final-starter]  | branch: step2 |  bundle exec rspec spec/requests/api/v1/merchants/coupons_request_spec.rb
# F.

# Failures:

#   1) Merchant Coupons Index GET /api/v1/merchants/:merchant_id/coupons returns all coupons for a specific merchant
#      Failure/Error: coupon2 = create(:coupon, merchant: merchant)
     
#      ActiveRecord::RecordInvalid:
#        Validation failed: Code has already been taken
#      # ./spec/requests/api/v1/merchants/coupons_request_spec.rb:8:in `block (3 levels) in <top (required)>'

# Finished in 0.23516 seconds (files took 1.73 seconds to load)
# 2 examples, 1 failure

# Failed examples:

# rspec ./spec/requests/api/v1/merchants/coupons_request_spec.rb:5 # Merchant Coupons Index GET /api/v1/merchants/:merchant_id/coupons returns all coupons for a specific merchant

