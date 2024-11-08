class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :discount_type, null: false
      t.float :discount_value, null: false
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end
