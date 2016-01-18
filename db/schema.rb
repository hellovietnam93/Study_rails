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

ActiveRecord::Schema.define(version: 20160118082246) do

  create_table "assignments", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "assignment_type", limit: 4
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "content",         limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "class_room_id",   limit: 4
  end

  add_index "assignments", ["class_room_id"], name: "index_assignments_on_class_room_id", using: :btree

  create_table "class_rooms", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "uid",                limit: 255
    t.text     "description",        limit: 65535
    t.integer  "course_id",          limit: 4
    t.integer  "semester_id",        limit: 4
    t.string   "enroll_key",         limit: 255
    t.integer  "class_type",         limit: 4
    t.integer  "registered_student", limit: 4
    t.integer  "max_student",        limit: 4
    t.string   "slug",               limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "status",             limit: 4
  end

  add_index "class_rooms", ["course_id"], name: "index_class_rooms_on_course_id", using: :btree
  add_index "class_rooms", ["semester_id"], name: "index_class_rooms_on_semester_id", using: :btree
  add_index "class_rooms", ["slug"], name: "index_class_rooms_on_slug", unique: true, using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "uid",               limit: 255
    t.text     "description",       limit: 65535
    t.decimal  "credit",                          precision: 10
    t.decimal  "credit_fee",                      precision: 10
    t.decimal  "theory_duration",                 precision: 10
    t.decimal  "exercise_duration",               precision: 10
    t.decimal  "practice_duration",               precision: 10
    t.decimal  "weight",                          precision: 10
    t.string   "en_name",           limit: 255
    t.string   "abbr_name",         limit: 255
    t.string   "language",          limit: 255
    t.text     "evaluation",        limit: 65535
    t.string   "slug",              limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "courses", ["slug"], name: "index_courses_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "group_classes", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "class_room_id", limit: 4
    t.integer  "user_id",       limit: 4
    t.string   "slug",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "group_classes", ["class_room_id"], name: "index_group_classes_on_class_room_id", using: :btree
  add_index "group_classes", ["slug"], name: "index_group_classes_on_slug", unique: true, using: :btree
  add_index "group_classes", ["user_id"], name: "index_group_classes_on_user_id", using: :btree

  create_table "prime_classes", force: :cascade do |t|
    t.string   "semester",     limit: 255
    t.string   "student_id",   limit: 255
    t.integer  "class_id",     limit: 4
    t.string   "class_type",   limit: 255
    t.string   "course_id",    limit: 255
    t.string   "course_title", limit: 255
    t.string   "reg_status",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "prime_users", force: :cascade do |t|
    t.string   "uid",         limit: 255
    t.string   "first_name",  limit: 255
    t.datetime "birthday"
    t.string   "program",     limit: 255
    t.string   "class_name",  limit: 255
    t.string   "status",      limit: 255
    t.string   "cohort",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "middle_name", limit: 255
    t.string   "last_name",   limit: 255
  end

  create_table "semesters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "semesters", ["slug"], name: "index_semesters_on_slug", unique: true, using: :btree

  create_table "user_classes", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "class_room_id", limit: 4
    t.integer  "status",        limit: 4
    t.boolean  "owner",                   default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "user_classes", ["class_room_id"], name: "index_user_classes_on_class_room_id", using: :btree
  add_index "user_classes", ["user_id"], name: "index_user_classes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "slug",                   limit: 255
    t.integer  "role",                   limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "assignments", "class_rooms"
  add_foreign_key "class_rooms", "courses"
  add_foreign_key "class_rooms", "semesters"
  add_foreign_key "group_classes", "class_rooms"
  add_foreign_key "group_classes", "users"
  add_foreign_key "user_classes", "class_rooms"
  add_foreign_key "user_classes", "users"
end
