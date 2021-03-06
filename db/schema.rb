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

ActiveRecord::Schema.define(:version => 20121207214641) do

  create_table "activities", :force => true do |t|
    t.string    "description"
    t.timestamp "date_and_time",                       :null => false
    t.integer   "min_participants",                    :null => false
    t.integer   "max_participants"
    t.boolean   "its_on",           :default => false
    t.timestamp "created_at",                          :null => false
    t.timestamp "updated_at",                          :null => false
    t.integer   "category_id"
    t.string    "title"
    t.integer   "creator_id"
    t.string    "where"
    t.integer   "zipcode"
    t.float     "latitude"
    t.float     "longitude"
  end

  create_table "activity_group_relations", :force => true do |t|
    t.integer   "activity_id"
    t.integer   "group_id"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
  end

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.integer   "parent_category_id"
    t.string    "image_path"
    t.timestamp "created_at",         :null => false
    t.timestamp "updated_at",         :null => false
    t.boolean   "leaf"
  end

  create_table "comments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "activity_id"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
    t.string    "title"
    t.string    "body"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer   "member_id"
    t.integer   "group_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string    "name"
    t.string    "details"
    t.timestamp "created_at",                       :null => false
    t.timestamp "updated_at",                       :null => false
    t.integer   "creator_id"
    t.boolean   "open_to_public", :default => true
  end

  create_table "invites", :force => true do |t|
    t.integer  "host_id"
    t.string   "guest_email"
    t.integer  "group_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "response"
  end

  create_table "participations", :force => true do |t|
    t.integer   "user_id"
    t.integer   "activity_id"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer   "subscriber_id"
    t.integer   "category_id"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "email",                    :default => "",    :null => false
    t.string    "encrypted_password",       :default => "",    :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",            :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                                  :null => false
    t.timestamp "updated_at",                                  :null => false
    t.string    "first_name"
    t.string    "last_name"
    t.string    "username"
    t.integer   "age"
    t.integer   "zipcode"
    t.boolean   "admin",                    :default => false
    t.boolean   "notf_new_activity",        :default => true
    t.boolean   "notf_activity_turns_on",   :default => true
    t.boolean   "notf_new_comment",         :default => true
    t.float     "latitude"
    t.float     "longitude"
    t.integer   "public_distance_notf_max"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
