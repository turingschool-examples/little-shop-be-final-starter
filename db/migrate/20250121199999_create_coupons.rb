class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :code, null: false   # Fixed ArgumentError.new("Unknown key.
                                    # Unique promotional code 
      t.string :discount_type, null: false # Can be % or "amount"
      t.decimal :discount_amount, precision: 10, scale: 2, null: false  
      #	precision: 10 means the number can have up to 10 digits in total.
      # scale: 2 means 2 decimal places (e.g., 10.99 or 5.00)
      t.string :status, null: false, default: "inactive"
      # 
      t.references :merchant, null: false, foreign_key: true

      t.timestamps

      t.index :code, unique: true  # ✅ This correctly enforces uniqueness
    end
  end
end