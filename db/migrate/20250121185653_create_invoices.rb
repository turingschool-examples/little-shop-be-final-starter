class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.bigint :customer_id, null: false
      t.bigint :merchant_id, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
