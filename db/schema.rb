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

ActiveRecord::Schema.define(version: 20160423160419) do

  create_table "answers", force: :cascade do |t|
    t.text     "content",     limit: 65535
    t.integer  "question_id", limit: 4
    t.boolean  "correct"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "assignment_histories", force: :cascade do |t|
    t.integer  "user_id",              limit: 4
    t.integer  "class_room_id",        limit: 4
    t.integer  "assignment_id",        limit: 4
    t.text     "content",              limit: 65535
    t.integer  "assignment_submit_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "editor",               limit: 4
  end

  add_index "assignment_histories", ["assignment_id"], name: "index_assignment_histories_on_assignment_id", using: :btree
  add_index "assignment_histories", ["assignment_submit_id"], name: "index_assignment_histories_on_assignment_submit_id", using: :btree
  add_index "assignment_histories", ["class_room_id"], name: "index_assignment_histories_on_class_room_id", using: :btree
  add_index "assignment_histories", ["user_id"], name: "index_assignment_histories_on_user_id", using: :btree

  create_table "assignment_submits", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "class_room_id", limit: 4
    t.integer  "assignment_id", limit: 4
    t.string   "title",         limit: 255
    t.text     "content",       limit: 65535
    t.decimal  "score",                       precision: 10
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "policy",        limit: 4
  end

  add_index "assignment_submits", ["assignment_id"], name: "index_assignment_submits_on_assignment_id", using: :btree
  add_index "assignment_submits", ["class_room_id"], name: "index_assignment_submits_on_class_room_id", using: :btree
  add_index "assignment_submits", ["user_id"], name: "index_assignment_submits_on_user_id", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "assignment_type", limit: 4
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "content",         limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "class_room_id",   limit: 4
  end

  add_index "assignments", ["class_room_id"], name: "index_assignments_on_class_room_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

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
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "status",             limit: 4
    t.string   "student_key",        limit: 255
  end

  add_index "class_rooms", ["course_id"], name: "index_class_rooms_on_course_id", using: :btree
  add_index "class_rooms", ["semester_id"], name: "index_class_rooms_on_semester_id", using: :btree

  create_table "class_teams", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "team_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "class_teams", ["team_id"], name: "index_class_teams_on_team_id", using: :btree
  add_index "class_teams", ["user_id"], name: "index_class_teams_on_user_id", using: :btree

  create_table "comment_hierarchies", force: :cascade do |t|
    t.integer "ancestor_id",   limit: 4, null: false
    t.integer "descendant_id", limit: 4, null: false
    t.integer "generations",   limit: 4, null: false
  end

  add_index "comment_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_udx", unique: true, using: :btree
  add_index "comment_hierarchies", ["descendant_id"], name: "comment_desc_idx", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.integer  "post_id",    limit: 4
    t.integer  "parent_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "course_references", force: :cascade do |t|
    t.integer  "course_id",  limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "course_references", ["course_id"], name: "index_course_references_on_course_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "uid",               limit: 255
    t.text     "description",       limit: 65535
    t.decimal  "theory_duration",                 precision: 10
    t.decimal  "exercise_duration",               precision: 10
    t.decimal  "practice_duration",               precision: 10
    t.decimal  "weight",                          precision: 10
    t.text     "evaluation",        limit: 65535
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.string   "attachment",    limit: 255
    t.integer  "user_id",       limit: 4
    t.integer  "class_room_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "documents", ["class_room_id"], name: "index_documents_on_class_room_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "event_users", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "status",     limit: 4, default: 0
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "event_users", ["event_id"], name: "index_event_users_on_event_id", using: :btree
  add_index "event_users", ["user_id"], name: "index_event_users_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "event_type",    limit: 4
    t.integer  "class_room_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "events", ["class_room_id"], name: "index_events_on_class_room_id", using: :btree
  add_index "events", ["event_type"], name: "index_events_on_event_type", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "forums", force: :cascade do |t|
    t.integer  "class_room_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "forums", ["class_room_id"], name: "index_forums_on_class_room_id", using: :btree

  create_table "group_users", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "group_id",   limit: 4
    t.boolean  "manager"
    t.integer  "status",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "group_users", ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_users", ["group_id"], name: "index_group_users_on_group_id", using: :btree
  add_index "group_users", ["user_id"], name: "index_group_users_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "picture",    limit: 255
    t.integer  "permisson",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "likeable_id",   limit: 4
    t.string   "likeable_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "likes", ["likeable_id"], name: "index_likes_on_likeable_id", using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "online_tests", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "class_room_id", limit: 4
    t.integer  "question_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "online_tests", ["class_room_id"], name: "index_online_tests_on_class_room_id", using: :btree
  add_index "online_tests", ["question_id"], name: "index_online_tests_on_question_id", using: :btree
  add_index "online_tests", ["user_id"], name: "index_online_tests_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "content",       limit: 65535
    t.integer  "user_id",       limit: 4
    t.integer  "postable_id",   limit: 4
    t.string   "postable_type", limit: 255
    t.integer  "class_room_id", limit: 4
    t.boolean  "approved",                    default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "posts", ["class_room_id"], name: "index_posts_on_class_room_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

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

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "school",     limit: 255
    t.string   "address",    limit: 255
    t.string   "phone",      limit: 255
    t.string   "uid",        limit: 255
    t.datetime "birthday"
    t.string   "program",    limit: 255
    t.string   "class_name", limit: 255
    t.string   "cohort",     limit: 255
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "name",          limit: 65535
    t.integer  "class_room_id", limit: 4
    t.integer  "question_type", limit: 4
    t.integer  "priority",      limit: 4
    t.integer  "course_id",     limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "questions", ["class_room_id"], name: "index_questions_on_class_room_id", using: :btree
  add_index "questions", ["course_id"], name: "index_questions_on_course_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "question_id",    limit: 4
    t.integer  "answer_id",      limit: 4
    t.integer  "online_test_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "results", ["answer_id"], name: "index_results_on_answer_id", using: :btree
  add_index "results", ["online_test_id"], name: "index_results_on_online_test_id", using: :btree
  add_index "results", ["question_id"], name: "index_results_on_question_id", using: :btree

  create_table "semesters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "syllabus_details", force: :cascade do |t|
    t.integer  "syllabus_id", limit: 4
    t.integer  "course_id",   limit: 4
    t.string   "title",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "syllabus_details", ["course_id"], name: "index_syllabus_details_on_course_id", using: :btree
  add_index "syllabus_details", ["syllabus_id"], name: "index_syllabus_details_on_syllabus_id", using: :btree

  create_table "syllabuses", force: :cascade do |t|
    t.integer  "course_id",  limit: 4
    t.string   "title",      limit: 255
    t.integer  "week",       limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "syllabuses", ["course_id"], name: "index_syllabuses_on_course_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "class_room_id", limit: 4
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "teams", ["class_room_id"], name: "index_teams_on_class_room_id", using: :btree

  create_table "timetable_details", force: :cascade do |t|
    t.integer  "timetable_id",       limit: 4
    t.integer  "syllabus_detail_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "timetable_details", ["syllabus_detail_id"], name: "index_timetable_details_on_syllabus_detail_id", using: :btree
  add_index "timetable_details", ["timetable_id"], name: "index_timetable_details_on_timetable_id", using: :btree

  create_table "timetables", force: :cascade do |t|
    t.integer  "class_room_id", limit: 4
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "title",         limit: 255
    t.text     "content",       limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "timetables", ["class_room_id"], name: "index_timetables_on_class_room_id", using: :btree

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
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "username",               limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "avatar",                 limit: 255
    t.boolean  "verified",                           default: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,     null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "role",                   limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "answers", "questions"
  add_foreign_key "assignment_histories", "assignment_submits"
  add_foreign_key "assignment_histories", "assignments"
  add_foreign_key "assignment_histories", "class_rooms"
  add_foreign_key "assignment_histories", "users"
  add_foreign_key "assignment_submits", "assignments"
  add_foreign_key "assignment_submits", "class_rooms"
  add_foreign_key "assignment_submits", "users"
  add_foreign_key "assignments", "class_rooms"
  add_foreign_key "class_rooms", "courses"
  add_foreign_key "class_rooms", "semesters"
  add_foreign_key "class_teams", "teams"
  add_foreign_key "class_teams", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "course_references", "courses"
  add_foreign_key "documents", "class_rooms"
  add_foreign_key "documents", "users"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "events", "class_rooms"
  add_foreign_key "events", "users"
  add_foreign_key "forums", "class_rooms"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "online_tests", "class_rooms"
  add_foreign_key "online_tests", "questions"
  add_foreign_key "online_tests", "users"
  add_foreign_key "posts", "class_rooms"
  add_foreign_key "posts", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "questions", "class_rooms"
  add_foreign_key "questions", "courses"
  add_foreign_key "results", "answers"
  add_foreign_key "results", "online_tests"
  add_foreign_key "results", "questions"
  add_foreign_key "syllabus_details", "courses"
  add_foreign_key "syllabus_details", "syllabuses"
  add_foreign_key "syllabuses", "courses"
  add_foreign_key "teams", "class_rooms"
  add_foreign_key "timetable_details", "syllabus_details"
  add_foreign_key "timetable_details", "timetables"
  add_foreign_key "timetables", "class_rooms"
  add_foreign_key "user_classes", "class_rooms"
  add_foreign_key "user_classes", "users"
end
