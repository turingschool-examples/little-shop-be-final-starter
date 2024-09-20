class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.references :merchant, foreign_key: true
      t.boolean :active, default: true 

      t.timestamps
    end
  end
end
