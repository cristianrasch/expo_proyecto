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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111119152624) do

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.integer  "exposition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  add_index "activities", ["exposition_id"], :name => "index_activities_on_exposition_id"
  add_index "activities", ["title", "exposition_id"], :name => "index_activities_on_title_and_exposition_id"

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
  end

  add_index "authors", ["name", "project_id"], :name => "index_authors_on_name_and_project_id"
  add_index "authors", ["project_id"], :name => "index_authors_on_project_id"

  create_table "expositions", :force => true do |t|
    t.integer  "year"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "users_deactivated", :default => false
  end

  add_index "expositions", ["name"], :name => "index_expositions_on_name", :unique => true
  add_index "expositions", ["start_date", "end_date"], :name => "index_expositions_on_start_date_and_end_date"
  add_index "expositions", ["year"], :name => "index_expositions_on_year", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.integer  "faculty",                    :limit => 2
    t.string   "subject"
    t.integer  "group_type",                 :limit => 2
    t.boolean  "competes_to_win_prizes",                  :default => false
    t.string   "contact"
    t.integer  "expo_mode",                  :limit => 2
    t.text     "description"
    t.integer  "exposition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "requirements"
    t.text     "lab_gear"
    t.integer  "sockets_count",                           :default => 0
    t.text     "needs_projector_reason"
    t.text     "needs_screen_reason"
    t.text     "needs_poster_hanger_reason"
    t.integer  "user_id"
    t.string   "other_faculty"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "other_group"
    t.integer  "approval_time"
    t.integer  "position"
  end

  add_index "projects", ["exposition_id"], :name => "index_projects_on_exposition_id"
  add_index "projects", ["title", "exposition_id"], :name => "index_projects_on_title_and_exposition_id"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                 :default => false
    t.boolean  "active",                                :default => true
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
