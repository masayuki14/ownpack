class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.references :recipe
      t.string :filepath
      t.string :memo
      t.integer :step_order

      t.timestamps
    end
    add_index :steps, :recipe_id
  end
end
