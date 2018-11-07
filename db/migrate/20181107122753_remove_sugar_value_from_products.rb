class RemoveSugarValueFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :sugar_value, :string
  end
end
