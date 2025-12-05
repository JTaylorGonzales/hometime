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

ActiveRecord::Schema[8.1].define(version: 2025_12_04_234403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "guests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_numbers", default: [], array: true
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "currency"
    t.datetime "end_date"
    t.string "guest_external_id"
    t.bigint "guest_id", null: false
    t.integer "nights"
    t.integer "number_of_adults"
    t.integer "number_of_children"
    t.integer "number_of_infants"
    t.integer "payout_price_in_cents"
    t.jsonb "raw_payload", default: {}
    t.integer "security_price_in_cents"
    t.datetime "start_date"
    t.integer "status", default: 0
    t.integer "total_price_in_cents"
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
  end

  add_foreign_key "reservations", "guests"
end
