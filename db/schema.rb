# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161105093206) do

  create_table "allocationcosts", force: :cascade do |t|
    t.integer  "stock_id"
    t.string   "title"
    t.integer  "allocation_amount"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "allocationcosts", ["stock_id"], name: "index_allocationcosts_on_stock_id"

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "method"
  end

  create_table "entrypatterns", force: :cascade do |t|
    t.string   "SKU"
    t.string   "kind_of_transaction"
    t.string   "kind_of_payment"
    t.string   "detail_of_payment"
    t.string   "handling"
    t.string   "debt"
    t.string   "credit"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.date     "date",                     null: false
    t.string   "country",                  null: false
    t.float    "rate",       default: 0.0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "exchanges", ["date", "country"], name: "exchange_index", unique: true

  create_table "expense_methods", force: :cascade do |t|
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_relations", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "subexpense_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "expense_relations", ["stock_id", "subexpense_id"], name: "index_expense_relations_on_stock_id_and_subexpense_id", unique: true
  add_index "expense_relations", ["stock_id"], name: "index_expense_relations_on_stock_id"
  add_index "expense_relations", ["subexpense_id"], name: "index_expense_relations_on_subexpense_id"

  create_table "expense_titles", force: :cascade do |t|
    t.string   "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listingreports", force: :cascade do |t|
    t.string   "sku"
    t.string   "asin"
    t.integer  "price"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pladmins", force: :cascade do |t|
    t.date     "date"
    t.string   "order_num"
    t.string   "sku"
    t.string   "goods_name"
    t.integer  "sale_amount"
    t.integer  "commission"
    t.integer  "cgs_amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "money_receive"
  end

  create_table "sales", force: :cascade do |t|
    t.date     "date"
    t.string   "order_num"
    t.string   "SKU"
    t.string   "kind_of_transaction"
    t.string   "kind_of_payment"
    t.string   "detail_of_payment"
    t.integer  "amount"
    t.integer  "quantity"
    t.string   "goods_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.date     "money_receive"
    t.string   "handling"
  end

  create_table "stockaccepts", force: :cascade do |t|
    t.date     "date"
    t.string   "fnsku"
    t.string   "sku"
    t.string   "goods_name"
    t.integer  "quantity"
    t.string   "fba_number"
    t.string   "fc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "asin"
  end

  create_table "stocks", force: :cascade do |t|
    t.date     "date"
    t.string   "asin"
    t.string   "goods_name"
    t.integer  "number"
    t.float    "unit_price"
    t.date     "money_paid"
    t.string   "purchase_from"
    t.string   "currency"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "sku"
    t.float    "rate"
    t.integer  "grandtotal"
  end

  create_table "subexpenses", force: :cascade do |t|
    t.string   "item"
    t.string   "method"
    t.date     "date"
    t.string   "purchase_from"
    t.float    "amount"
    t.string   "targetgood"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "rate"
    t.string   "currency"
  end

end
