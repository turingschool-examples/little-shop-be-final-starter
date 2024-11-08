class AddMerchantIdToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :merchant_id, :bigint
    add_index :coupons, :merchant_id
    add_foreign_key :coupons, :merchants
  end
end
