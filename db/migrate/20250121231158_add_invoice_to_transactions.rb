class AddInvoiceToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :invoice, null: false, foreign_key: true
  end
end
