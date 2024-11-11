# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
# puts "Loading PostgreSQL Data dump into local database with command:"
# puts cmd
# system(cmd)

seedMerchant = Merchant.create!(
  name: "Temporary Store"
)

seedMerchant2 = Merchant.create!(
  name: "Not Too Active"
)

Coupon.create!(
  name: "First time",
  code: "WELCOME10",
  discount_type: "percent_off",
  discount_value: 10.0,
  status:true,
  merchant: seedMerchant
)
Coupon.create!(
  name: "Summer Sale",
  code: "SUMMER25",
  discount_type: "percent_off",
  discount_value: 25.0,
  status: true,
  merchant: seedMerchant
)
Coupon.create!(
  name: "We Miss You",
  code: "WELCOMEBACK",
  discount_type: "dollar_off",
  discount_value: 10.0,
  status:true,
  merchant: seedMerchant
)
Coupon.create!(
  name: "Case of the Mondays",
  code: "BETTERTHANNOTHING",
  discount_type: "dollar_off",
  discount_value: 1.0,
  status: true,
  merchant: seedMerchant
)
Coupon.create!(
  name: "Crazy Time",
  code: "NEVER50",
  discount_type: "percent_off",
  discount_value: 50.0,
  status: false,
  merchant: seedMerchant2
)
Coupon.create!(
  name: "Going Out of Business",
  code: "BYE40",
  discount_type: "percent_off",
  discount_value: 40.0,
  status: false,
  merchant: seedMerchant2
)
Coupon.create!(
  name: "Liquidation",
  code: "LAUNDERING25",
  discount_type: "dollar_off",
  discount_value: 25.0,
  status: false,
  merchant: seedMerchant2
)
Coupon.create!(
  name: "Lucky",
  code: "SEVEN13",
  discount_type: "dollar_off",
  discount_value: 7.13,
  status: false,
  merchant: seedMerchant2
)