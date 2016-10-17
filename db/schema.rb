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

ActiveRecord::Schema.define(version: 20161017113602) do

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

  create_table "stocks", force: :cascade do |t|
    t.date     "date"
    t.string   "asin"
    t.string   "goods_name"
    t.integer  "number"
    t.integer  "unit_price"
    t.date     "money_paid"
    t.string   "purchase_from"
    t.string   "country"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
