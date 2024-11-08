class CreateCoupon < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.float :discount
      t.boolean :percent_discount
      t.boolean :active

      t.timestamps
    end
  end
end
