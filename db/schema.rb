# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 1) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ips", id: :serial, force: :cascade do |t|
    t.string "address", null: false
    t.index ["address"], name: "index_ips_on_address", unique: true
  end

  create_table "ips_users", id: false, force: :cascade do |t|
    t.integer "ip_id", null: false
    t.integer "user_id", null: false
    t.index ["ip_id", "user_id"], name: "index_ips_users_on_ip_id_and_user_id", unique: true
  end

  create_table "marks", id: :serial, force: :cascade do |t|
    t.integer "mark", null: false
    t.integer "post_id", null: false
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "body", null: false
    t.integer "marks_count", default: 0
    t.float "avg_mark"
    t.integer "ip_id", null: false
    t.integer "user_id", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login", null: false
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "marks", "posts"
  add_foreign_key "posts", "ips"
  add_foreign_key "posts", "users"
end
