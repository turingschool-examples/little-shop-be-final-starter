class CouponUse < ApplicationRecord
  belongs_to :coupon
  belongs_to :customer
  
  # Callback to increment the coupon's used count
  after_create :increment_coupon_used_count

  private

  def increment_coupon_used_count
    # Increment the coupon's used_count by 1 each time a coupon use is created
    coupon.increment!(:used_count)
  end
end

# If you want a more detailed view of coupon usage, you'd track each individual use via CouponUse. So, the coupon_uses.count would represent how many times a coupon has been used, and CouponUse would not need to track used_count because it's inherently tied to the number of rows in the coupon_uses table.

# The used_count field could either be automatically updated via a callback in CouponUse, or you could just count the associated coupon_uses to get the same information.

# Example Structure
# Here’s an example of how you might use the CouponUse model:

# Coupon: The actual coupon object, like "10% off" or "Buy One Get One Free".
# CouponUse: An individual usage of a coupon, where a customer uses a coupon on a transaction.
# Example Flow
# Customer uses a coupon: You create a CouponUse record that links a customer and a coupon.
# # Update the coupon's usage count: After the CouponUse is created, the Coupon model's used_count (either through a counter column or by counting coupon_uses) is updated.