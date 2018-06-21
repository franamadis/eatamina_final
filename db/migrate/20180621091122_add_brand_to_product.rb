class AddBrandToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :brand, :string
    add_column :products, :nutrition_grade, :string
  end
end
