class AddCouponToInvoices < ActiveRecord::Migration[7.1]
  def change
    if table_exists?(:invoices)
      add_reference :invoices, :coupon, foreign_key: true, null: true
    end
  end
end