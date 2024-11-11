class MakeCouponIdNullableInInvoices < ActiveRecord::Migration[7.1]
  def change
    if table_exists?(:invoices)
      change_column_null :invoices, :coupon_id, true
    end
  end
end
