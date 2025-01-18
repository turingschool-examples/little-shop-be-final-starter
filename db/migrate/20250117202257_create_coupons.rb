class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true}
      t.decimal :percent_off, precision: 5, scale: 2
      t.decimal :dollar_off, precision: 10, scale: 2 
      t.boolean :active, null: false
      t.bigint "merchant_id", null: false
      t.index ["merchant_id"], name: "index_coupons_on_merchant_id"
      t.foreign_key :merchants   
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
    end
  end
end
