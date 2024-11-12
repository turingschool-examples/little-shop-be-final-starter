class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:transactions)
      create_table :transactions do |t|
        t.references :invoice, foreign_key: true
        t.string :credit_card_number
        t.string :credit_card_expiration_date
        t.string :result
        t.timestamps
      end
    end
  end
end
