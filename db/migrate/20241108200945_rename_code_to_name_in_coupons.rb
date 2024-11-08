class RenameCodeToNameInCoupons < ActiveRecord::Migration[7.1]
  def change
    rename_column :coupons, :code, :name
  end
end
