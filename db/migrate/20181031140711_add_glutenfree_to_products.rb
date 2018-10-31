class AddGlutenfreeToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :glutenfree, :boolean
  end
end
