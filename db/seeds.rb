# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
#

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)


# Coupon.create!(name: 'Buy One Get One 50% Off', code: 'BOGO50', dollar_off: nil, percent_off: 50, status: 'active', merchant_id: 1)
# Coupon.create!(name: 'Buy One Get 5 Dollars Off', code: 'BOG5OFF', dollar_off: 5.0, percent_off: nil, status: 'active', merchant_id: 1)
# Coupon.create!(name: 'Buy Twenty Get One Free', code: 'B20G1F', dollar_off: nil, percent_off: 100, status: 'active', merchant_id: 1)
# Coupon.create!(name: 'Free For All', code: 'F4A', dollar_off: nil, percent_off: 100, status: 'inactive', merchant_id: 1)
# Coupon.create!(name: 'Buy 2 Get 10% Off ', code: 'B2G10P', dollar_off: nil, percent_off: 10, status: 'active', merchant_id: 1)
# Coupon.create!(name: 'Buy 15 Get 20% Off', code: 'B15G20P', dollar_off: nil, percent_off: 20, status: 'active', merchant_id: 2)
# Coupon.create!(name: 'Buy 100 Get 100% Off', code: 'B100G100P', dollar_off: nil, percent_off: 100, status: 'active', merchant_id: 2)
# Coupon.create!(name: 'Buy 25 Get 19% Off', code: 'B25G19P', dollar_off: nil, percent_off: 19, status: 'active', merchant_id: 3)


# Invoice.create!(customer_id: 1, merchant_id: 1, status: 'shipped', coupon_id: 1)
# Invoice.create!(customer_id: 2, merchant_id: 2, status: 'shipped', coupon_id: 6)
# Invoice.create!(customer_id: 3, merchant_id: 3, status: 'shipped', coupon_id: 8)
# Invoice.create!(customer_id: 1, merchant_id: 1, status: 'shipped', coupon_id: 2)
# Invoice.create!(customer_id: 2, merchant_id: 1, status: 'returned', coupon_id: 3)
# Invoice.create!(customer_id: 3, merchant_id: 1, status: 'shipped', coupon_id:4)
# Invoice.create!(customer_id: 1, merchant_id: 1, status: 'returned', coupon_id: 5)
# Invoice.create!(customer_id: 2, merchant_id: 2, status: 'packaged', coupon_id: 7)


