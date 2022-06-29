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

ActiveRecord::Schema[7.0].define(version: 2022_06_28_190200) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.integer "role", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "bikes", force: :cascade do |t|
    t.float "price"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "category_id"
    t.bigint "admin_id"
    t.string "name"
    t.string "description"
    t.string "license_plates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_bikes_on_admin_id"
    t.index ["category_id"], name: "index_bikes_on_category_id"
    t.index ["license_plates"], name: "index_bikes_on_license_plates", unique: true
    t.index ["user_id"], name: "index_bikes_on_user_id"
  end

  create_table "booking_statuses", force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_statuses_on_booking_id"
    t.index ["user_id"], name: "index_booking_statuses_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "bike_id"
    t.date "booking_start_day"
    t.date "booking_end_day"
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["bike_id"], name: "index_bookings_on_bike_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.date "start_day"
    t.date "end_day"
    t.bigint "bike_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_calendars_on_bike_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.boolean "paid", default: false
    t.string "token"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "order_id"
    t.string "payer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.integer "role", default: 0
    t.string "address"
    t.string "phone_number"
    t.string "activation_digest"
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bikes", "admins"
  add_foreign_key "bikes", "categories"
  add_foreign_key "bikes", "users"
  add_foreign_key "booking_statuses", "bookings"
  add_foreign_key "booking_statuses", "users"
  add_foreign_key "bookings", "bikes"
  add_foreign_key "bookings", "users"
  add_foreign_key "calendars", "bikes"
end
