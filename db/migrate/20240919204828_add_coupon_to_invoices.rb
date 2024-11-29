class AddCouponToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :coupon, null: true, foreign_key: true
  end
end
