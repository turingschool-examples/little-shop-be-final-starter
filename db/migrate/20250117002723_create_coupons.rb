class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.decimal :percent_off
      t.decimal :dollar_off

      t.timestamps
    end
  end
end
