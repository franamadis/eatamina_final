class AddOrganicToProduct < ActiveRecord::Migration[5.2]
    def change
      add_column :products, :organic, :boolean
    end
end