class AddEffectToAdditives < ActiveRecord::Migration[5.2]
  def change
    add_column :additives, :effect, :string
  end
end
