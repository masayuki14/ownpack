# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121030054937) do

  create_table "omniusers", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "screen_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "recipes", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "history"
    t.string   "catch_copy"
    t.string   "knack"
    t.integer  "time_required", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "filepath"
    t.boolean  "active",        :default => false
  end

  create_table "steps", :force => true do |t|
    t.integer  "recipe_id"
    t.string   "filepath"
    t.string   "memo"
    t.integer  "step_order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "steps", ["recipe_id"], :name => "index_steps_on_recipe_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "twitter_uid"
    t.string   "twitter_name"
    t.string   "twitter_screen_name"
  end

end
