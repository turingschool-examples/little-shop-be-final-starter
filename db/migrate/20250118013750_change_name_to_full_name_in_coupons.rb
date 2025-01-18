class ChangeNameToFullNameInCoupons < ActiveRecord::Migration[7.1]
  def change
    rename_column :coupons, :name, :full_name 
  end
end
