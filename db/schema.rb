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

ActiveRecord::Schema[8.0].define(version: 2025_09_19_174053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_and_followed", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "sleep_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "sleep_at", null: false
    t.datetime "wake_at"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sleep_at"], name: "index_sleep_sessions_on_sleep_at"
    t.index ["user_id", "created_at", "duration"], name: "index_sleep_sessions_on_user_id_and_created_at_and_duration"
    t.index ["user_id", "created_at"], name: "index_sleep_sessions_on_user_id_and_created_at"
    t.index ["user_id", "sleep_at"], name: "index_sleep_sessions_finished", where: "(wake_at IS NOT NULL)"
    t.index ["user_id"], name: "index_sleep_sessions_on_user_id"
    t.index ["wake_at"], name: "index_sleep_sessions_on_wake_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "sleep_sessions", "users"
end
