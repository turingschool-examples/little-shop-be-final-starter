class AddCouponIdToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :coupon_id, :bigint, null: true
    add_foreign_key :invoices, :coupons  
    add_index :invoices, :coupon_id
  end
end


