class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.references :user
      t.string :title
      t.string :history
      t.string :catch_copy
      t.string :knack
      t.integer :time_required

      t.timestamps
    end
  end
end
