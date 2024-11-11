class AddCouponsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.float :discount_value
      t.string :discount_type
      t.boolean :active, default: true
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
