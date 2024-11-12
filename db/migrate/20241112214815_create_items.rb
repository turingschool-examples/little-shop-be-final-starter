class CreateItems < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:items)
      create_table :items do |t|
        t.string :name
        t.string :description
        t.float :unit_price
        t.references :merchant, foreign_key: true
        t.timestamps
      end
    end
  end
end
