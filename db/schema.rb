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

ActiveRecord::Schema.define(version: 20171120050524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banking_informations", force: :cascade do |t|
    t.string   "account_number"
    t.string   "routing_info"
    t.string   "bank_name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "account_name"
  end

  create_table "deposits", force: :cascade do |t|
    t.decimal  "amount",                 default: "0.0"
    t.date     "date_of_deposit"
    t.string   "authorization_code",     default: ""
    t.string   "attachment",             default: ""
    t.integer  "status",                 default: 0
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "banking_information_id"
    t.index ["user_id"], name: "index_deposits_on_user_id", using: :btree
  end

  create_table "ledger_entries", force: :cascade do |t|
    t.decimal  "credit",     default: "0.0"
    t.decimal  "debit",      default: "0.0"
    t.decimal  "balance",    default: "0.0"
    t.integer  "user_id"
    t.integer  "entry_id"
    t.string   "entry_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.string   "ref"
    t.decimal  "amount"
    t.integer  "user_id"
    t.integer  "trade_line_id"
    t.integer  "status"
    t.integer  "purchased_by_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "file_for_special_add"
    t.string   "reason_for_rejection", default: ""
    t.string   "file_for_ssn"
    t.string   "file_for_dl"
    t.index ["purchased_by_id"], name: "index_purchases_on_purchased_by_id", using: :btree
    t.index ["trade_line_id"], name: "index_purchases_on_trade_line_id", using: :btree
  end

  create_table "refunds", force: :cascade do |t|
    t.string   "ref",                   default: ""
    t.string   "reason",                default: ""
    t.string   "cm_service",            default: ""
    t.string   "cm_login",              default: ""
    t.string   "cm_password",           default: ""
    t.decimal  "amount",                default: "0.0"
    t.integer  "status",                default: 0
    t.string   "reason_for_rejection",  default: ""
    t.string   "reason_for_inprogress", default: ""
    t.integer  "purchase_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.decimal  "amount_refunded"
    t.string   "attachment"
    t.index ["purchase_id"], name: "index_refunds_on_purchase_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.decimal  "ssn_charge", default: "0.0"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "ssns", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ssnorcpn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  create_table "states", force: :cascade do |t|
    t.string   "name",       default: ""
    t.string   "short_code", default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "trade_lines", force: :cascade do |t|
    t.integer  "slots",           default: 0
    t.string   "bank",            default: ""
    t.decimal  "credit_limit",    default: "0.0"
    t.date     "history"
    t.integer  "state_id"
    t.boolean  "special_add",     default: false
    t.boolean  "ssn_req",         default: false
    t.boolean  "dl_req",          default: false
    t.decimal  "price",           default: "0.0"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_active",       default: false
    t.integer  "statement_date"
    t.date     "expiration_date"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.text     "address",                default: ""
    t.string   "zipcode",                default: ""
    t.string   "phone",                  default: ""
    t.string   "username",               default: ""
    t.decimal  "wallet_balance",         default: "0.0"
    t.integer  "status"
    t.integer  "role"
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "invited_by_id"
    t.string   "profile"
    t.date     "date_of_birth"
    t.string   "mother_maiden_name"
    t.string   "city"
    t.string   "state"
    t.string   "social",                 default: ""
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["status"], name: "index_users_on_status", using: :btree
  end

  create_table "withdraws", force: :cascade do |t|
    t.decimal  "amount",         default: "0.0"
    t.integer  "withdraw_by_id"
    t.integer  "status",         default: 0
    t.string   "ref",            default: ""
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "payee"
    t.text     "address"
    t.index ["withdraw_by_id"], name: "index_withdraws_on_withdraw_by_id", using: :btree
  end

end
