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

require 'faker'

merchants = Merchant.all

if merchants.any?
  merchants.each do |merchant|
    10.times do
      Coupon.create!(
        name: Faker::Commerce.promotion_code,
        code: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
        active: [true, false].sample,
        merchant: merchant
      )
    end
  end
  puts "10 coupons created for each merchant!"
else
  puts "No merchants found. Please seed merchants first!"
end