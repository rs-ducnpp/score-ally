# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_27_132101) do
  create_table "charts", force: :cascade do |t|
    t.integer "point", default: 0, null: false
    t.integer "round", default: 0, null: false
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rule_id", null: false
    t.index ["room_id"], name: "index_charts_on_room_id"
    t.index ["rule_id"], name: "index_charts_on_rule_id"
    t.index ["user_id"], name: "index_charts_on_user_id"
  end

  create_table "room_users", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id", "user_id"], name: "index_room_users_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_room_users_on_room_id"
    t.index ["user_id"], name: "index_room_users_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.boolean "show_total_point", default: false
    t.integer "room_type", default: 0, null: false
    t.integer "limit_point"
    t.integer "limit_round"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chart_id"
    t.integer "rule_id"
    t.index ["chart_id"], name: "index_rooms_on_chart_id"
    t.index ["room_type"], name: "index_rooms_on_room_type"
    t.index ["rule_id"], name: "index_rooms_on_rule_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "rules", force: :cascade do |t|
    t.integer "point_type", default: 0, null: false
    t.integer "point", default: 0, null: false
    t.text "description"
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_rules_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "charts", "rooms"
  add_foreign_key "charts", "rules"
  add_foreign_key "charts", "users"
  add_foreign_key "room_users", "rooms"
  add_foreign_key "room_users", "users"
  add_foreign_key "rooms", "charts"
  add_foreign_key "rooms", "rules"
  add_foreign_key "rooms", "users"
  add_foreign_key "rules", "rooms"
end
