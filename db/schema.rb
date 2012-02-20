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

ActiveRecord::Schema.define(:version => 20120106052651) do

  create_table "brands", :primary_key => "brand_id", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
  end

  create_table "categories", :primary_key => "category_id", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
  end

  create_table "products", :primary_key => "product_id", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "brand_id"
    t.integer  "category_id"
    t.string   "description", :default => ""
    t.string   "origin",      :default => ""
    t.boolean  "is_enabled",  :default => true
    t.float    "price",       :default => 0.0
    t.datetime "created_at"
  end

  add_index "products", ["brand_id"], :name => "brand_id"
  add_index "products", ["category_id"], :name => "category_id"

  create_table "skus", :id => false, :force => true do |t|
    t.integer "product_id",  :default => 0,    :null => false
    t.string  "sku_part",                      :null => false
    t.string  "short_name"
    t.string  "description",                   :null => false
    t.integer "amount",      :default => 0
    t.float   "price"
    t.boolean "is_enabled",  :default => true
  end

end
