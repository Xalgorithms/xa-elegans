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

ActiveRecord::Schema.define(version: 20161115041641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "associations", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "rule_id"
    t.integer "transformation_id"
  end

  add_index "associations", ["rule_id"], name: "index_associations_on_rule_id", using: :btree
  add_index "associations", ["transaction_id"], name: "index_associations_on_transaction_id", using: :btree
  add_index "associations", ["transformation_id"], name: "index_associations_on_transformation_id", using: :btree

  create_table "changes", force: :cascade do |t|
    t.integer "document_id"
    t.jsonb   "content"
    t.integer "rule_id"
  end

  add_index "changes", ["document_id"], name: "index_changes_on_document_id", using: :btree
  add_index "changes", ["rule_id"], name: "index_changes_on_rule_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.xml    "src"
    t.string "public_id"
    t.jsonb  "content"
  end

  create_table "events", force: :cascade do |t|
    t.string "public_id"
    t.string "event_type"
  end

  create_table "gcm_registrations", force: :cascade do |t|
    t.string  "token"
    t.integer "user_id"
  end

  add_index "gcm_registrations", ["user_id"], name: "index_gcm_registrations_on_user_id", using: :btree

  create_table "invoice_push_events", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "event_id"
    t.string  "transaction_public_id"
    t.string  "document_public_id"
  end

  add_index "invoice_push_events", ["event_id"], name: "index_invoice_push_events_on_event_id", using: :btree
  add_index "invoice_push_events", ["transaction_id"], name: "index_invoice_push_events_on_transaction_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer "transact_id"
    t.string  "public_id"
  end

  add_index "invoices", ["transact_id"], name: "index_invoices_on_transact_id", using: :btree

  create_table "register_events", force: :cascade do |t|
    t.integer "user_id"
    t.string  "token"
    t.integer "event_id"
    t.string  "user_public_id"
  end

  add_index "register_events", ["event_id"], name: "index_register_events_on_event_id", using: :btree
  add_index "register_events", ["user_id"], name: "index_register_events_on_user_id", using: :btree

  create_table "revisions", force: :cascade do |t|
    t.integer "document_id"
    t.integer "invoice_id"
  end

  add_index "revisions", ["document_id"], name: "index_revisions_on_document_id", using: :btree
  add_index "revisions", ["invoice_id"], name: "index_revisions_on_invoice_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.string "reference"
    t.string "public_id"
  end

  create_table "settings_update_events", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "settings_update_events", ["event_id"], name: "index_settings_update_events_on_event_id", using: :btree
  add_index "settings_update_events", ["user_id"], name: "index_settings_update_events_on_user_id", using: :btree

  create_table "sync_attempts", force: :cascade do |t|
    t.string "token"
  end

  create_table "tradeshift_keys", force: :cascade do |t|
    t.string  "key"
    t.string  "secret"
    t.string  "tenant_id"
    t.integer "user_id"
  end

  add_index "tradeshift_keys", ["user_id"], name: "index_tradeshift_keys_on_user_id", using: :btree

  create_table "tradeshift_sync_events", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "tradeshift_sync_events", ["event_id"], name: "index_tradeshift_sync_events_on_event_id", using: :btree
  add_index "tradeshift_sync_events", ["user_id"], name: "index_tradeshift_sync_events_on_user_id", using: :btree

  create_table "tradeshift_sync_states", force: :cascade do |t|
    t.datetime "last_sync"
    t.integer  "document_id"
  end

  add_index "tradeshift_sync_states", ["document_id"], name: "index_tradeshift_sync_states_on_document_id", using: :btree

  create_table "transaction_add_invoice_events", force: :cascade do |t|
    t.string  "transaction_public_id"
    t.string  "url"
    t.integer "transaction_id"
    t.integer "event_id"
    t.integer "invoice_id"
    t.integer "document_id"
  end

  add_index "transaction_add_invoice_events", ["document_id"], name: "index_transaction_add_invoice_events_on_document_id", using: :btree
  add_index "transaction_add_invoice_events", ["event_id"], name: "index_transaction_add_invoice_events_on_event_id", using: :btree
  add_index "transaction_add_invoice_events", ["invoice_id"], name: "index_transaction_add_invoice_events_on_invoice_id", using: :btree
  add_index "transaction_add_invoice_events", ["transaction_id"], name: "index_transaction_add_invoice_events_on_transaction_id", using: :btree

  create_table "transaction_associate_rule_events", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "rule_id"
    t.integer "event_id"
    t.string  "transaction_public_id"
    t.string  "rule_public_id"
    t.integer "transformation_id"
    t.string  "transformation_public_id"
  end

  add_index "transaction_associate_rule_events", ["event_id"], name: "index_transaction_associate_rule_events_on_event_id", using: :btree
  add_index "transaction_associate_rule_events", ["rule_id"], name: "index_transaction_associate_rule_events_on_rule_id", using: :btree
  add_index "transaction_associate_rule_events", ["transaction_id"], name: "index_transaction_associate_rule_events_on_transaction_id", using: :btree
  add_index "transaction_associate_rule_events", ["transformation_id"], name: "index_transaction_associate_rule_events_on_transformation_id", using: :btree

  create_table "transaction_bind_source_events", force: :cascade do |t|
    t.string  "source"
    t.integer "transaction_id"
    t.integer "event_id"
    t.string  "transaction_public_id"
  end

  add_index "transaction_bind_source_events", ["event_id"], name: "index_transaction_bind_source_events_on_event_id", using: :btree
  add_index "transaction_bind_source_events", ["transaction_id"], name: "index_transaction_bind_source_events_on_transaction_id", using: :btree

  create_table "transaction_close_events", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "event_id"
    t.string  "transaction_public_id"
  end

  add_index "transaction_close_events", ["event_id"], name: "index_transaction_close_events_on_event_id", using: :btree

  create_table "transaction_execute_events", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "event_id"
    t.string  "transaction_public_id"
  end

  add_index "transaction_execute_events", ["event_id"], name: "index_transaction_execute_events_on_event_id", using: :btree
  add_index "transaction_execute_events", ["transaction_id"], name: "index_transaction_execute_events_on_transaction_id", using: :btree

  create_table "transaction_open_events", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "transaction_id"
    t.string  "user_public_id"
  end

  add_index "transaction_open_events", ["event_id"], name: "index_transaction_open_events_on_event_id", using: :btree
  add_index "transaction_open_events", ["transaction_id"], name: "index_transaction_open_events_on_transaction_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
    t.string   "public_id"
    t.string   "source"
  end

  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "transformation_add_events", force: :cascade do |t|
    t.string  "name"
    t.integer "event_id"
    t.integer "transformation_id"
    t.string  "src"
  end

  add_index "transformation_add_events", ["event_id"], name: "index_transformation_add_events_on_event_id", using: :btree
  add_index "transformation_add_events", ["transformation_id"], name: "index_transformation_add_events_on_transformation_id", using: :btree

  create_table "transformation_destroy_events", force: :cascade do |t|
    t.string  "public_id"
    t.integer "event_id"
  end

  add_index "transformation_destroy_events", ["event_id"], name: "index_transformation_destroy_events_on_event_id", using: :btree

  create_table "transformations", force: :cascade do |t|
    t.string "public_id"
    t.string "name"
    t.string "src"
    t.jsonb  "content"
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
    t.string   "public_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "associations", "rules"
  add_foreign_key "associations", "transactions"
  add_foreign_key "associations", "transformations"
  add_foreign_key "invoice_push_events", "events"
  add_foreign_key "invoice_push_events", "transactions"
  add_foreign_key "invoices", "transactions", column: "transact_id"
  add_foreign_key "revisions", "documents"
  add_foreign_key "revisions", "invoices"
  add_foreign_key "tradeshift_keys", "users"
  add_foreign_key "tradeshift_sync_events", "events"
  add_foreign_key "tradeshift_sync_events", "users"
  add_foreign_key "transaction_associate_rule_events", "events"
  add_foreign_key "transaction_associate_rule_events", "rules"
  add_foreign_key "transaction_associate_rule_events", "transactions"
  add_foreign_key "transaction_associate_rule_events", "transformations"
  add_foreign_key "transaction_close_events", "events"
  add_foreign_key "transaction_open_events", "events"
  add_foreign_key "transactions", "users"
  add_foreign_key "transformation_add_events", "events"
  add_foreign_key "transformation_destroy_events", "events"
end
