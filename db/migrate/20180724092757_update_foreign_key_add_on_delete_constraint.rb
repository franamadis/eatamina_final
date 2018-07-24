class UpdateForeignKeyAddOnDeleteConstraint < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :queries, :products
    add_foreign_key :queries, :products, on_delete: :cascade
  end
end
