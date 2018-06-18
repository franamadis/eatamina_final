class CreateAdditives < ActiveRecord::Migration[5.2]
  def change
    create_table :additives do |t|
      t.string :name
      t.string :code
      t.string :description
      t.string :risk

      t.timestamps
    end
  end
end
