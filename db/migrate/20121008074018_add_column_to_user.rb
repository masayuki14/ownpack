class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid, :string
    add_column :users, :twitter_name, :string
    add_column :users, :twitter_screen_name, :string
  end
end
