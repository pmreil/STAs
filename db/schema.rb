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

ActiveRecord::Schema.define(:version => 20110613120530) do

  create_table "company_industries", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_sectors", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fund_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fund_families", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "securities", :force => true do |t|
    t.string   "ticker",                             :null => false
    t.string   "name",                :limit => 128, :null => false
    t.integer  "exchange_id",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fund_category_id"
    t.integer  "fund_family_id"
    t.integer  "company_industry_id"
    t.integer  "company_sector_id"
    t.string   "security_type"
  end

  create_table "security_exchanges", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "security_views", :force => true do |t|
    t.integer  "security_id"
    t.string   "viewer_ip_address"
    t.string   "viewer_browser_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
