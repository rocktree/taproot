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

ActiveRecord::Schema.define(version: 20150204232623) do

  create_table "documents", force: true do |t|
    t.integer  "site_id"
    t.string   "document_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idx",           default: 0
    t.text     "crop_data"
    t.string   "document_site"
    t.string   "document_name"
  end

  create_table "form_fields", force: true do |t|
    t.integer  "form_id"
    t.string   "title"
    t.string   "data_type"
    t.text     "options"
    t.boolean  "required",      default: false
    t.integer  "position",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "label"
    t.string   "placeholder"
    t.string   "default_value"
    t.boolean  "show_label",    default: true
  end

  create_table "form_submissions", force: true do |t|
    t.integer  "form_id"
    t.integer  "idx",        default: 0
    t.text     "field_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.text     "body"
    t.text     "thank_you_body"
    t.text     "notification_emails"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.string   "button_label"
    t.string   "email_subject"
    t.text     "email_body"
    t.integer  "email_to_id"
  end

  create_table "image_croppings", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "site_id"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_galleries", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "slug"
    t.boolean  "public",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "template_id"
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.text     "body"
    t.string   "ancestry"
    t.boolean  "published",   default: false
    t.text     "field_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",    default: 0
    t.string   "template"
    t.string   "order"
    t.boolean  "show_in_nav", default: true
    t.text     "body_md"
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree

  create_table "site_users", force: true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.boolean  "site_admin", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home_page_id"
    t.string   "git_url"
    t.text     "secondary_urls"
  end

  create_table "template_fields", force: true do |t|
    t.integer  "template_group_id"
    t.string   "title"
    t.string   "slug"
    t.string   "data_type"
    t.text     "options"
    t.boolean  "required",          default: false
    t.integer  "position",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "protected",         default: false
  end

  create_table "template_groups", force: true do |t|
    t.integer  "template_id"
    t.string   "title"
    t.string   "slug"
    t.integer  "position",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "page_templates"
    t.text     "children"
    t.string   "order_method"
    t.string   "order_direction"
    t.boolean  "can_be_root",     default: false
    t.boolean  "limit_pages",     default: false
    t.integer  "max_pages"
    t.text     "form_groups"
    t.text     "form_fields"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.text     "settings"
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_access_token"
    t.datetime "fb_token_expires"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
