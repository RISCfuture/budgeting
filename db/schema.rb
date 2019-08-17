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

ActiveRecord::Schema.define(version: 2019_08_17_233850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "category", limit: 126, null: false
    t.string "name", limit: 126, null: false
    t.decimal "unit_amount", precision: 10, scale: 2, null: false
    t.integer "quantity", default: 1, null: false
    t.integer "period_count", default: 1, null: false
    t.integer "period_unit", limit: 2, null: false
    t.boolean "income", default: false, null: false
    t.boolean "budget", default: false, null: false
    t.boolean "sales_tax", default: false, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "name"], name: "index_items_on_category_and_name", unique: true
    t.index ["income", "category", "name"], name: "index_items_on_income_and_category_and_name"
  end

end
