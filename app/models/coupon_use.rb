class CouponUse < ApplicationRecord
  belongs_to :coupon
  belongs_to :customer

  after_create :increment_coupon_used_count
  
end
