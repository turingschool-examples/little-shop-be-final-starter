class AddCouponToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :coupon, null: false, foreign_key: true, null: true
  end
end
