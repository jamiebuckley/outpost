# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_26_153554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessibilities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accessibilities_locations", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "accessibility_id", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "service_id"
    t.string "name"
    t.string "title"
    t.index ["service_id"], name: "index_contacts_on_service_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "address_1"
    t.string "city"
    t.string "state_province"
    t.string "postal_code"
    t.string "country"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.text "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_notes_on_service_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "email"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "old_external_id"
  end

  create_table "phones", force: :cascade do |t|
    t.bigint "contact_id"
    t.string "number"
    t.index ["contact_id"], name: "index_phones_on_contact_id"
  end

  create_table "send_needs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "send_needs_services", id: false, force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "send_need_id", null: false
  end

  create_table "service_at_locations", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "location_id", null: false
    t.string "service_name"
    t.text "service_description"
    t.string "service_url"
    t.string "service_email"
    t.string "postcode"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
  end

  create_table "service_taxonomies", force: :cascade do |t|
    t.bigint "taxonomy_id"
    t.bigint "service_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_service_taxonomies_on_service_id"
    t.index ["taxonomy_id"], name: "index_service_taxonomies_on_taxonomy_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "organisation_id"
    t.string "name"
    t.text "description"
    t.string "email"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.boolean "approved", default: true
    t.string "type"
    t.date "visible_from"
    t.date "visible_to"
    t.index ["discarded_at"], name: "index_services_on_discarded_at"
    t.index ["organisation_id"], name: "index_services_on_organisation_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.json "object"
    t.string "action"
    t.bigint "user_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "object_changes"
    t.index ["service_id"], name: "index_snapshots_on_service_id"
    t.index ["user_id"], name: "index_snapshots_on_user_id"
  end

  create_table "taxonomies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_taxonomies_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organisation_id"
    t.boolean "admin"
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_seen"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.json "taxonomies"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "watches", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_watches_on_service_id"
    t.index ["user_id"], name: "index_watches_on_user_id"
  end

  add_foreign_key "notes", "services"
  add_foreign_key "notes", "users"
  add_foreign_key "snapshots", "services"
  add_foreign_key "snapshots", "users"
end
