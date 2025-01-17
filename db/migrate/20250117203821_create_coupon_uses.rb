class CreateCouponUses < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_uses do |t|
      t.references :coupon, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
