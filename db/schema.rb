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

ActiveRecord::Schema.define(version: 20170309080039) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "account"
    t.string   "debit_credit"
    t.string   "bs_pl"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "destroy_check",    default: false, null: false
    t.string   "display_position"
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id"

  create_table "allocationcosts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.string   "title"
    t.integer  "allocation_amount"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "allocationcosts", ["stock_id"], name: "index_allocationcosts_on_stock_id"
  add_index "allocationcosts", ["user_id"], name: "index_allocationcosts_on_user_id"

  create_table "banks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "banks", ["user_id"], name: "index_banks_on_user_id"

  create_table "currencies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "method"
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "currencies", ["user_id"], name: "index_currencies_on_user_id"

  create_table "disposals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sale_id"
    t.integer  "stock_id"
    t.date     "date"
    t.string   "order_num"
    t.string   "sku"
    t.integer  "number"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "disposals", ["sale_id"], name: "index_disposals_on_sale_id"
  add_index "disposals", ["stock_id"], name: "index_disposals_on_stock_id"
  add_index "disposals", ["user_id"], name: "index_disposals_on_user_id"

  create_table "dummy_stocks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.date     "sale_date"
    t.integer  "number"
    t.boolean  "destroy_check", default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "cancel_date"
  end

  add_index "dummy_stocks", ["stock_id"], name: "index_dummy_stocks_on_stock_id"
  add_index "dummy_stocks", ["user_id"], name: "index_dummy_stocks_on_user_id"

  create_table "entrypatterns", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "sku"
    t.string   "kind_of_transaction"
    t.string   "kind_of_payment"
    t.string   "detail_of_payment"
    t.string   "handling"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "destroy_check",       default: false, null: false
  end

  add_index "entrypatterns", ["user_id"], name: "index_entrypatterns_on_user_id"

  create_table "exchanges", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date",                          null: false
    t.string   "country",                       null: false
    t.float    "rate",          default: 0.0,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "exchanges", ["user_id"], name: "index_exchanges_on_user_id"

  create_table "expense_methods", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "expense_methods", ["user_id"], name: "index_expense_methods_on_user_id"

  create_table "expense_relations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.integer  "subexpense_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "expense_relations", ["stock_id", "subexpense_id"], name: "index_expense_relations_on_stock_id_and_subexpense_id", unique: true
  add_index "expense_relations", ["stock_id"], name: "index_expense_relations_on_stock_id"
  add_index "expense_relations", ["subexpense_id"], name: "index_expense_relations_on_subexpense_id"
  add_index "expense_relations", ["user_id"], name: "index_expense_relations_on_user_id"

  create_table "expense_titles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "item"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "method"
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "expense_titles", ["user_id"], name: "index_expense_titles_on_user_id"

  create_table "expenseledgers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sale_id"
    t.date     "date"
    t.string   "content"
    t.integer  "amount"
    t.float    "rate"
    t.date     "money_paid"
    t.string   "purchase_from"
    t.string   "currency"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "grandtotal"
    t.string   "account_name"
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "expenseledgers", ["sale_id"], name: "index_expenseledgers_on_sale_id"
  add_index "expenseledgers", ["user_id"], name: "index_expenseledgers_on_user_id"

  create_table "financial_statements", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "period_start"
    t.string   "monthly_yearly"
    t.string   "account"
    t.integer  "amount"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "financial_statements", ["user_id"], name: "index_financial_statements_on_user_id"

  create_table "generalledgers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "pladmin_id"
    t.integer  "stock_id"
    t.integer  "stockreturn_id"
    t.integer  "return_good_id"
    t.integer  "disposal_id"
    t.integer  "expenseledger_id"
    t.integer  "voucher_id"
    t.integer  "subexpense_id"
    t.integer  "expense_relation_id"
    t.date     "date"
    t.string   "debit_account"
    t.string   "debit_subaccount"
    t.string   "debit_taxcode"
    t.string   "credit_account"
    t.string   "credit_subaccount"
    t.string   "credit_taxcode"
    t.string   "content"
    t.string   "trade_company"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "amount"
    t.boolean  "destroy_check",       default: false, null: false
  end

  add_index "generalledgers", ["disposal_id"], name: "index_generalledgers_on_disposal_id"
  add_index "generalledgers", ["expense_relation_id"], name: "index_generalledgers_on_expense_relation_id"
  add_index "generalledgers", ["expenseledger_id"], name: "index_generalledgers_on_expenseledger_id"
  add_index "generalledgers", ["pladmin_id"], name: "index_generalledgers_on_pladmin_id"
  add_index "generalledgers", ["return_good_id"], name: "index_generalledgers_on_return_good_id"
  add_index "generalledgers", ["stock_id"], name: "index_generalledgers_on_stock_id"
  add_index "generalledgers", ["stockreturn_id"], name: "index_generalledgers_on_stockreturn_id"
  add_index "generalledgers", ["subexpense_id"], name: "index_generalledgers_on_subexpense_id"
  add_index "generalledgers", ["user_id"], name: "index_generalledgers_on_user_id"
  add_index "generalledgers", ["voucher_id"], name: "index_generalledgers_on_voucher_id"

  create_table "journalpatterns", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "taxcode"
    t.string   "pattern"
    t.string   "debit_account"
    t.string   "debit_subaccount"
    t.string   "debit_taxcode"
    t.string   "credit_account"
    t.string   "credit_subaccount"
    t.string   "credit_taxcode"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "ledger"
    t.boolean  "destroy_check",     default: false, null: false
  end

  add_index "journalpatterns", ["user_id"], name: "index_journalpatterns_on_user_id"

  create_table "listingreports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "sku"
    t.string   "asin"
    t.integer  "price"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "listingreports", ["user_id"], name: "index_listingreports_on_user_id"

  create_table "multi_channels", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sale_id"
    t.string   "order_num"
    t.string   "sku"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "destroy_check", default: false, null: false
    t.integer  "number",        default: 1,     null: false
    t.date     "date"
  end

  add_index "multi_channels", ["sale_id"], name: "index_multi_channels_on_sale_id"
  add_index "multi_channels", ["user_id"], name: "index_multi_channels_on_user_id"

  create_table "periods", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "period_start"
    t.date     "period_end"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "monthly_yearly"
  end

  add_index "periods", ["user_id"], name: "index_periods_on_user_id"

  create_table "pladmins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sale_id"
    t.integer  "stock_id"
    t.date     "date"
    t.string   "order_num"
    t.string   "sku"
    t.string   "goods_name"
    t.integer  "sale_amount"
    t.integer  "commission"
    t.integer  "cgs_amount"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.date     "money_receive"
    t.string   "sale_place"
    t.integer  "shipping_cost"
    t.date     "commission_pay_date"
    t.date     "shipping_pay_date"
    t.integer  "quantity"
    t.boolean  "destroy_check",       default: false, null: false
  end

  add_index "pladmins", ["sale_id"], name: "index_pladmins_on_sale_id"
  add_index "pladmins", ["stock_id"], name: "index_pladmins_on_stock_id"
  add_index "pladmins", ["user_id"], name: "index_pladmins_on_user_id"

  create_table "point_coupons", force: :cascade do |t|
    t.string   "order_num"
    t.integer  "shop_coupon"
    t.integer  "use_point"
    t.integer  "use_coupon"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  add_index "point_coupons", ["user_id"], name: "index_point_coupons_on_user_id"

  create_table "rakuten_costs", force: :cascade do |t|
    t.date     "billing_date"
    t.integer  "pc_usage_fee"
    t.integer  "mobile_usage_fee"
    t.integer  "pc_vest_point"
    t.integer  "mobile_vest_point"
    t.integer  "affiliate_reward"
    t.integer  "affiliate_system_fee"
    t.integer  "r_card_plus"
    t.integer  "system_improvement_fee"
    t.integer  "open_shop_fee"
    t.date     "payment_date"
    t.integer  "sales_bracket"
    t.float    "pc_rate"
    t.float    "mobile_rate"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id"
    t.boolean  "destroy_check",          default: false, null: false
  end

  add_index "rakuten_costs", ["user_id"], name: "index_rakuten_costs_on_user_id"

  create_table "rakuten_settings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "start_sales"
    t.float    "pc_rate"
    t.float    "mobile_rate"
    t.boolean  "destroy_check",   default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "end_sales"
    t.integer  "pc_addition"
    t.integer  "mobile_addition"
  end

  add_index "rakuten_settings", ["user_id"], name: "index_rakuten_settings_on_user_id"

  create_table "rakuten_temps", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "order_num"
    t.date     "order_date"
    t.date     "sale_date"
    t.string   "kind_of_card"
    t.string   "brand"
    t.string   "content"
    t.string   "installment"
    t.integer  "receipt_amount"
    t.float    "rate"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.date     "closing_date"
    t.date     "money_receipt_date"
    t.integer  "total_sales"
  end

  add_index "rakuten_temps", ["user_id"], name: "index_rakuten_temps_on_user_id"

  create_table "rakutens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "order_num"
    t.date     "sale_date"
    t.string   "goods_name"
    t.string   "pc_mobile"
    t.integer  "unit_price"
    t.integer  "number"
    t.integer  "shipping_cost"
    t.integer  "consumption_tax"
    t.integer  "cod_fee"
    t.integer  "shop_coupon"
    t.integer  "commission"
    t.integer  "vest_point"
    t.integer  "system_improvement"
    t.integer  "credit_commission"
    t.integer  "data_processing"
    t.string   "settlement"
    t.integer  "use_point"
    t.integer  "use_coupon"
    t.date     "money_receipt_date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "sku"
    t.integer  "total_sales"
    t.integer  "total_commissions"
    t.boolean  "destroy_check",      default: false, null: false
    t.date     "closing_date"
    t.string   "option"
    t.date     "order_date"
    t.integer  "receipt_amount"
    t.date     "point_receipt_date"
    t.string   "kind_of_card"
    t.integer  "shipping_payment"
    t.date     "billing_date"
    t.integer  "minyukin"
  end

  add_index "rakutens", ["user_id"], name: "index_rakutens_on_user_id"

  create_table "return_goods", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sale_id"
    t.integer  "stock_id"
    t.string   "order_num"
    t.string   "old_sku"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "new_sku"
    t.integer  "number",        default: 1
    t.date     "date"
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "return_goods", ["sale_id"], name: "index_return_goods_on_sale_id"
  add_index "return_goods", ["stock_id"], name: "index_return_goods_on_stock_id"
  add_index "return_goods", ["user_id"], name: "index_return_goods_on_user_id"

  create_table "sales", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.string   "order_num"
    t.string   "sku"
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

  add_index "sales", ["user_id"], name: "index_sales_on_user_id"

  create_table "selfstorages", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "sku"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "stock_id"
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "selfstorages", ["user_id"], name: "index_selfstorages_on_user_id"

  create_table "stockaccepts", force: :cascade do |t|
    t.integer  "user_id"
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

  add_index "stockaccepts", ["user_id"], name: "index_stockaccepts_on_user_id"

  create_table "stockledgers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.date     "transaction_date"
    t.string   "sku"
    t.string   "asin"
    t.string   "goods_name"
    t.integer  "number"
    t.integer  "unit_price"
    t.integer  "grandtotal"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "classification"
  end

  add_index "stockledgers", ["stock_id"], name: "index_stockledgers_on_stock_id"
  add_index "stockledgers", ["user_id"], name: "index_stockledgers_on_user_id"

  create_table "stockreturns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.date     "date"
    t.string   "sku"
    t.string   "asin"
    t.string   "goods_name"
    t.integer  "number"
    t.float    "unit_price"
    t.float    "rate"
    t.integer  "goods_amount"
    t.date     "money_paid"
    t.string   "purchase_from"
    t.string   "currency"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "destroy_check", default: false, null: false
    t.integer  "grandtotal"
  end

  add_index "stockreturns", ["stock_id"], name: "index_stockreturns_on_stock_id"
  add_index "stockreturns", ["user_id"], name: "index_stockreturns_on_user_id"

  create_table "stocks", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.string   "asin"
    t.string   "goods_name"
    t.integer  "number"
    t.float    "unit_price"
    t.date     "money_paid"
    t.string   "purchase_from"
    t.string   "currency"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "sku"
    t.float    "rate"
    t.integer  "grandtotal"
    t.integer  "goods_amount"
    t.boolean  "destroy_check", default: false, null: false
    t.integer  "sold_unit",     default: 0
    t.boolean  "soldout_check", default: false, null: false
  end

  add_index "stocks", ["user_id"], name: "index_stocks_on_user_id"

  create_table "subexpenses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "item"
    t.date     "date"
    t.string   "purchase_from"
    t.float    "amount"
    t.string   "targetgood"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.float    "rate"
    t.string   "currency"
    t.date     "money_paid"
    t.boolean  "destroy_check", default: false, null: false
  end

  add_index "subexpenses", ["user_id"], name: "index_subexpenses_on_user_id"

  create_table "summaries", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "closing_date"
    t.integer  "total_sales"
    t.string   "bank"
    t.date     "money_receipt_date"
    t.boolean  "destroy_check",      default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "summaries", ["user_id"], name: "index_summaries_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "postal_code"
    t.string   "address"
    t.string   "telephone_number"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "furigana"
    t.string   "consumption_tax"
    t.string   "entity"
    t.date     "start_date"
    t.integer  "closing_date",     default: 12
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "vouchers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sale_id"
    t.date     "date"
    t.string   "debit_account"
    t.string   "credit_account"
    t.string   "content"
    t.string   "trade_company"
    t.integer  "amount"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "debit_subaccount"
    t.string   "debit_taxcode"
    t.string   "credit_subaccount"
    t.string   "credit_taxcode"
    t.boolean  "destroy_check",     default: false, null: false
  end

  add_index "vouchers", ["sale_id"], name: "index_vouchers_on_sale_id"
  add_index "vouchers", ["user_id"], name: "index_vouchers_on_user_id"

  create_table "yafuokus", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.date     "date"
    t.string   "order_num"
    t.string   "sku"
    t.integer  "unit_price"
    t.integer  "number",              default: 1
    t.integer  "sales_amount"
    t.integer  "cogs_amount"
    t.integer  "commission"
    t.integer  "shipping_cost"
    t.date     "money_receipt_date"
    t.date     "shipping_pay_date"
    t.boolean  "destroy_check",       default: false, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "sale_place"
    t.date     "commission_pay_date"
    t.string   "goods_name"
  end

  add_index "yafuokus", ["stock_id"], name: "index_yafuokus_on_stock_id"
  add_index "yafuokus", ["user_id"], name: "index_yafuokus_on_user_id"

  create_table "yahoo_shoppings", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.string   "order_id"
    t.integer  "unit_price"
    t.integer  "number",             default: 1
    t.integer  "sales_amount"
    t.integer  "commission"
    t.integer  "cogs_amount"
    t.integer  "shipping_cost"
    t.date     "money_receipt_date"
    t.date     "shipping_pay_date"
    t.boolean  "destroy_check",      default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "sku"
    t.string   "goods_name"
  end

  add_index "yahoo_shoppings", ["user_id"], name: "index_yahoo_shoppings_on_user_id"

end
