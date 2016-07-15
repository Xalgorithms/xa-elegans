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

ActiveRecord::Schema.define(version: 20151107175842) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id"

  create_table "assignments", force: :cascade do |t|
    t.integer "invocation_id"
    t.integer "parameter_id"
    t.string  "actual"
  end

  add_index "assignments", ["invocation_id"], name: "index_assignments_on_invocation_id"
  add_index "assignments", ["parameter_id"], name: "index_assignments_on_parameter_id"

  create_table "invocations", force: :cascade do |t|
    t.integer "account_id"
    t.integer "rule_id"
  end

  add_index "invocations", ["account_id"], name: "index_invocations_on_account_id"
  add_index "invocations", ["rule_id"], name: "index_invocations_on_rule_id"

  create_table "invoices", force: :cascade do |t|
    t.integer "account_id"
    t.date    "effective"
  end

  add_index "invoices", ["account_id"], name: "index_invoices_on_account_id"

  create_table "parameters", force: :cascade do |t|
    t.integer "rule_id"
    t.string  "name"
  end

  add_index "parameters", ["rule_id"], name: "index_parameters_on_rule_id"

  create_table "rules", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "full_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
