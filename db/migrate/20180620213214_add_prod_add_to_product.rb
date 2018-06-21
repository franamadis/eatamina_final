class AddProdAddToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :prod_add, :string
  end
end
