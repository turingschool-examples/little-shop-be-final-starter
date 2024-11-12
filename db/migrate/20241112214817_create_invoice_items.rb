class CreateInvoiceItems < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:invoice_items)
      create_table :invoice_items do |t|
        t.references :item, foreign_key: true
        t.references :invoice, foreign_key: true
        t.integer :quantity
        t.float :unit_price
        t.timestamps
      end
    end
  end
end
