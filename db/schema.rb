# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090919214301) do

  create_table "contexts", :force => true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", :force => true do |t|
    t.string   "symbol"
    t.string   "company"
    t.float    "shares"
    t.date     "buy_date"
    t.decimal  "buy_price"
    t.date     "sell_date"
    t.decimal  "sell_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sold",       :default => false
    t.decimal  "price"
  end

  create_table "tags", :force => true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todos", :force => true do |t|
    t.string   "label"
    t.datetime "due_at"
    t.datetime "done_at"
    t.integer  "project_id"
    t.string   "raw_input"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "done",       :default => false
    t.integer  "context_id"
  end

  create_table "todos_tags", :force => true do |t|
    t.integer "todo_id"
    t.integer "tag_id"
  end

end
