class AddDiscountTypeAndValueToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :discount_type, :string, null: false
    add_column :coupons, :discount_value, :decimal, null: false
  end
end
