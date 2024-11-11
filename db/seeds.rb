# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

# Create Merchant Coupons
# FactoryBot.create(:coupon, name:"BOGO", merchant:112)
# FactoryBot.create_list(:coupon, 2, active:false, name:"BOGO", merchant_id: 112)

# Check if Merchants can have more than 5 active coupons
# merchant = Merchant.find_by(name: "Test Merchant") || Merchant.create!(name: "Test Merchant")
# 5.times do |i|
#   Coupon.create!(
#     name: "Coupon #{i + 1}",
#     code: "UNIQUE_CODE_#{Time.now.to_i}_#{i}", # Ensuring unique codes
#     discount_value: 10,
#     discount_type: "percent",
#     merchant: merchant,
#     active: true
#   )
# end
# sixth_coupon = Coupon.new(
#   name: "Coupon 6",
#   code: "UNIQUE_CODE_6",
#   discount_value: 15,
#   discount_type: "percent",
#   merchant: merchant,
#   active: true
# )

# sixth_coupon.save

# puts "Saved successfully? #{sixth_coupon.persisted?}"
# puts "Errors: #{sixth_coupon.errors.full_messages}"

# Test usage_count
#merchant = Merchant.find_or_create_by(name: "Test Merchant")
# customer = Customer.find_or_create_by(first_name: "Test", last_name: "Customer")
# coupon = Coupon.create!(
#   name: "Discount",
#   code: "SAVE10now",
#   discount_value: 10,
#   discount_type: "percent",
#   merchant: merchant,
#   active: true
# )
# 3.times do
#   Invoice.create!(
#     status: "shipped",  # Ensure this status is valid in your model
#     coupon: coupon,
#     merchant: merchant,
#     customer: customer
#   )
# end
# puts coupon.usage_count  