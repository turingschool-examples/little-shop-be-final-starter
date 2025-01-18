class AddStatusToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :status, :string, default: 'active', null: false
  end
end
