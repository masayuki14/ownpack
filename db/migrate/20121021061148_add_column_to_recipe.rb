class AddColumnToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :filepath, :string
    add_column :recipes, :active, :boolean, :default => 0
    change_column_default :recipes, :time_required, 0
  end
end
