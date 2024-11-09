class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.string :discount_type
      t.decimal :discount_value
      t.integer :merchant_id
      t.boolean :status

      t.timestamps
    end
end