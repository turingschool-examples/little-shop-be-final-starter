class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:invoices)
      create_table :invoices do |t|
        t.references :customer, foreign_key: true
        t.references :merchant, foreign_key: true
        t.string :status
        t.timestamps
      end
    end
  end
end
