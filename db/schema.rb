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

ActiveRecord::Schema[7.1].define(version: 2025_01_18_173645) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupon_uses", force: :cascade do |t|
    t.bigint "coupon_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_coupon_uses_on_coupon_id"
    t.index ["customer_id"], name: "index_coupon_uses_on_customer_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.decimal "percent_off"
    t.decimal "dollar_off"
    t.bigint "merchant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "used_count", default: 0
    t.string "status", default: "active", null: false
    t.index ["merchant_id"], name: "index_coupons_on_merchant_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "invoice_id"
    t.integer "quantity"
    t.float "unit_price"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["item_id"], name: "index_invoice_items_on_item_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "merchant_id"
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "coupon_id"
    t.index ["coupon_id"], name: "index_invoices_on_coupon_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["merchant_id"], name: "index_invoices_on_merchant_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "unit_price"
    t.bigint "merchant_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["merchant_id"], name: "index_items_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "credit_card_number"
    t.string "credit_card_expiration_date"
    t.string "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id"
  end

  add_foreign_key "coupon_uses", "coupons"
  add_foreign_key "coupon_uses", "customers"
  add_foreign_key "coupons", "merchants"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "items"
  add_foreign_key "invoices", "coupons"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "merchants"
  add_foreign_key "items", "merchants"
  add_foreign_key "transactions", "invoices"
end
