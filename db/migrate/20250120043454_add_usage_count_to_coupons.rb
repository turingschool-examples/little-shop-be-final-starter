class AddUsageCountToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :usage_count, :integer, default: 0, null: false
  end
end
