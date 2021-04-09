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

ActiveRecord::Schema.define(version: 2021_04_09_064954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.uuid "uuid"
    t.string "mime"
    t.string "cid"
    t.bigint "file_size"
    t.bigint "disk_size"
    t.boolean "is_directory"
    t.integer "ref_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "failed_jobs", force: :cascade do |t|
    t.string "name"
    t.json "arguments"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "storage_histories", force: :cascade do |t|
    t.uuid "uuid"
    t.bigint "user_id", null: false
    t.string "secret"
    t.integer "storage"
    t.integer "months"
    t.integer "amount"
    t.string "currency", default: "usd"
    t.string "action", default: "N"
    t.boolean "paid", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "note"
    t.string "payment_type", default: "card"
    t.index ["user_id"], name: "index_storage_histories_on_user_id"
  end

  create_table "storages", force: :cascade do |t|
    t.uuid "uuid"
    t.bigint "user_id", null: false
    t.integer "storage"
    t.datetime "stop_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_storages_on_user_id"
  end

  create_table "temps", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "note"
    t.index ["key"], name: "index_temps_on_key", unique: true
  end

  create_table "user_attachment", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "attachment_id", null: false
    t.string "original_name"
    t.hstore "meta"
    t.datetime "pinned_date"
    t.datetime "unpinned_date"
    t.datetime "added_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "crust_status", default: 0
    t.index ["attachment_id"], name: "index_user_attachment_on_attachment_id"
    t.index ["user_id"], name: "index_user_attachment_on_user_id"
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "auth_token"
    t.datetime "expired_at"
    t.index ["auth_token"], name: "index_user_tokens_on_auth_token", unique: true
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.text "roles"
    t.string "password_digest"
    t.bigint "file_amount"
    t.bigint "disk_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "capacity", default: 0
    t.datetime "expired_at"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
