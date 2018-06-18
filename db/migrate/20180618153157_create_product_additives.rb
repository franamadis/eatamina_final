class CreateProductAdditives < ActiveRecord::Migration[5.2]
  def change
    create_table :product_additives do |t|
      t.references :additive, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
