class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.decimal :unit_price
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
