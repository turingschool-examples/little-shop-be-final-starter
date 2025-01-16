class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.float :dollar_off
      t.bigint :percent_off
      t.string :status

      t.timestamps
    end
  end
end
