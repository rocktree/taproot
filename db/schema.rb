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

ActiveRecord::Schema.define(version: 20150811152550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "item_path"
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "domains", force: true do |t|
    t.string   "title"
    t.integer  "site_id"
    t.integer  "redirect_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "hidden",        default: false
  end

  create_table "form_files", force: true do |t|
    t.integer  "form_submission_id"
    t.string   "file_uid"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "menu_items", force: true do |t|
    t.integer  "menu_id"
    t.integer  "page_id"
    t.string   "title"
    t.string   "slug"
    t.string   "url"
    t.integer  "position",   default: 0
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_items", ["ancestry"], name: "index_menu_items_on_ancestry", using: :btree

  create_table "menus", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_documents", force: true do |t|
    t.integer  "page_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_resources", force: true do |t|
    t.integer  "page_id"
    t.integer  "resource_id"
    t.text     "field_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.string   "ancestry"
    t.boolean  "published",  default: false
    t.text     "field_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   default: 0
    t.string   "page_path"
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree

  create_table "resource_association_fields", force: true do |t|
    t.integer  "resource_type_id"
    t.string   "title"
    t.string   "slug"
    t.string   "data_type"
    t.text     "options"
    t.boolean  "required",         default: false
    t.integer  "position",         default: 0
    t.string   "label"
    t.boolean  "protected",        default: false
    t.string   "default_value"
    t.boolean  "half_width",       default: false
    t.boolean  "hidden",           default: false
    t.boolean  "can_be_hidden",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_fields", force: true do |t|
    t.integer  "resource_type_id"
    t.string   "title"
    t.string   "slug"
    t.string   "data_type"
    t.text     "options"
    t.boolean  "required",         default: false
    t.integer  "position",         default: 0
    t.string   "label"
    t.boolean  "protected",        default: false
    t.string   "default_value"
    t.boolean  "half_width",       default: false
    t.boolean  "hidden",           default: false
    t.boolean  "can_be_hidden",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_types", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.string   "order_method"
    t.string   "order_direction"
    t.integer  "last_editor_id"
    t.boolean  "has_show_view",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "resource_type_id"
    t.text     "field_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_settings", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "git_url"
    t.string   "uid"
    t.json     "templates"
  end

  create_table "template_descendants", force: true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "label"
    t.boolean  "protected",         default: false
    t.boolean  "hidden",            default: false
    t.boolean  "can_be_hidden",     default: true
    t.string   "default_value"
    t.boolean  "half_width",        default: false
  end

  create_table "template_groups", force: true do |t|
    t.integer  "template_id"
    t.string   "title"
    t.string   "slug"
    t.integer  "position",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_resource_types", force: true do |t|
    t.integer  "template_id"
    t.integer  "resource_type_id"
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
    t.boolean  "can_be_root",        default: false
    t.boolean  "limit_pages",        default: false
    t.integer  "max_pages",          default: 0
    t.boolean  "maxed_out",          default: false
    t.integer  "last_editor_id"
    t.boolean  "has_show_view",      default: true
    t.boolean  "can_have_documents", default: false
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
    t.string   "api_key"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
