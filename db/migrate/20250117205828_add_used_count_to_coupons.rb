class AddUsedCountToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :used_count, :integer
  end
end
