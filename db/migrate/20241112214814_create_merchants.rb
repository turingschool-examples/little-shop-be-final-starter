class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
      unless table_exists?(:merchants)
      create_table :merchants do |t|
        t.string :name
        t.timestamps
      end
    end
  end
end
