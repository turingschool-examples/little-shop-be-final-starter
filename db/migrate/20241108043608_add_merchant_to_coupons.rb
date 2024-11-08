class AddMerchantToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_reference :coupons, :merchant, null: false, foreign_key: true
  end
end
