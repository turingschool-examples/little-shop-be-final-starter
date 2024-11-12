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

seedMerchant = Merchant.find_or_create_by!(
  name: "Temporary Store"
)

seedMerchant2 = Merchant.find_or_create_by!(
  name: "Not Too Active"
)

customer1 = Customer.find_or_create_by!(
  first_name: "Gregor",
  last_name: "Leggory"
)

customer2 = Customer.find_or_create_by!(
  first_name: "Constance",
  last_name: "Stumblebee"
)

Coupon.find_or_create_by!(
  name: "First time",
  code: "WELCOME10",
  discount_type: "percent_off",
  discount_value: 10.0,
  status: "active",
  merchant: seedMerchant
)
Coupon.find_or_create_by!(
  name: "Summer Sale",
  code: "SUMMER25",
  discount_type: "percent_off",
  discount_value: 25.0,
  status:  "active",
  merchant: seedMerchant
)
Coupon.find_or_create_by!(
  name: "We Miss You",
  code: "WELCOMEBACK",
  discount_type: "dollar_off",
  discount_value: 10.0,
  status: "active",
  merchant: seedMerchant
)
Coupon.find_or_create_by!(
  name: "Case of the Mondays",
  code: "BETTERTHANNOTHING",
  discount_type: "dollar_off",
  discount_value: 1.0,
  status:  "active",
  merchant: seedMerchant
)
Coupon.find_or_create_by!(
  name: "Crazy Time",
  code: "NEVER50",
  discount_type: "percent_off",
  discount_value: 50.0,
  status: "inactive",
  merchant: seedMerchant2
)
Coupon.find_or_create_by!(
  name: "Going Out of Business",
  code: "BYE40",
  discount_type: "percent_off",
  discount_value: 40.0,
  status: "inactive",
  merchant: seedMerchant2
)
Coupon.find_or_create_by!(
  name: "Liquidation",
  code: "LAUNDERING25",
  discount_type: "dollar_off",
  discount_value: 25.0,
  status: "inactive",
  merchant: seedMerchant2
)
Coupon.find_or_create_by!(
  name: "Lucky",
  code: "SEVEN13",
  discount_type: "dollar_off",
  discount_value: 7.13,
  status: "inactive",
  merchant: seedMerchant2
)

coupon1 = Coupon.find_by(code: "WELCOME10")
coupon2 = Coupon.find_by(code: "SUMMER25")
coupon3 = Coupon.find_by(code: "WELCOMEBACK")
coupon4 = Coupon.find_by(code: "BETTERTHANNOTHING")

invoice1 = Invoice.find_or_create_by!(
  merchant: seedMerchant,
  customer: customer1,
  status: "shipped",
  coupon: coupon1
)

invoice2 = Invoice.find_or_create_by!(
  merchant: seedMerchant,
  customer: customer2,
  status: "packaged",
  coupon: coupon2
)

invoice3 = Invoice.find_or_create_by!(
  merchant: seedMerchant2,
  customer: customer1,
  status: "returned",
  coupon: coupon3
)

invoice4 = Invoice.find_or_create_by!(
  merchant: seedMerchant2,
  customer: customer2,
  status: "shipped"
)

item1 = Item.find_or_create_by!(
  name: "Long String",
  description: "So Many Uses",
  unit_price: 39.99,
  merchant: seedMerchant
)

item2 = Item.find_or_create_by!(
  name: "Fingerless Oven Mits",
  description: "Enjoy the Adventure",
  unit_price: 5.99,
  merchant: seedMerchant2
)

InvoiceItem.find_or_create_by!(
  invoice: invoice1,
  item: item1,
  quantity: 3,
  unit_price: item1.unit_price
)

InvoiceItem.find_or_create_by!(
  invoice: invoice2,
  item: item2,
  quantity: 5,
  unit_price: item2.unit_price
)