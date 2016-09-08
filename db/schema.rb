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

ActiveRecord::Schema.define(version: 20160908025505) do

  create_table "book_groupships", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_groupships_on_book_id"
    t.index ["group_id"], name: "index_book_groupships_on_group_id"
  end

  create_table "books", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_public",      default: false
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "category_id"
    t.integer  "comment_number"
    t.integer  "views"
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "name"
    t.integer  "book_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "description"
    t.integer  "user_id"
    t.boolean  "is_public",   default: false
    t.index ["book_id"], name: "index_comments_on_book_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_likes_on_book_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "user_bookships", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_user_bookships_on_book_id"
    t.index ["user_id"], name: "index_user_bookships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "introduction"
    t.string   "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
