class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:coupons)
      create_table :coupons do |t|
        t.string :name
        t.string :code
        t.string :discount_type
        t.decimal :discount_value
        t.integer :merchant_id
        t.string :status
        t.timestamps
      end 
        add_index :coupons, :code, unique: true
        add_index :coupons, :status
    end
  end
end
