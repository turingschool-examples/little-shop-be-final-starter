class ChangeDefaultStatusToCoupons < ActiveRecord::Migration[7.1]
  def change
        change_column_default :coupons, :status, 'pending'
  end
end
