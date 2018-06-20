class ChangeCodeinAdditivesToChemical < ActiveRecord::Migration[5.2]
  def change
    rename_column :additives, :code, :chemical
  end
end
