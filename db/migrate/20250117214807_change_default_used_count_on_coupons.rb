class ChangeDefaultUsedCountOnCoupons < ActiveRecord::Migration[7.1]
  def change
    change_column_default :coupons, :used_count, 0
  end
end
