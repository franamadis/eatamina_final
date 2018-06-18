class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :response
      t.string :nutritional_info
      t.string :sku

      t.timestamps
    end
  end
end
