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

ActiveRecord::Schema.define(:version => 20100918203737) do

  create_table "brands", :force => true do |t|
    t.string   "domain_name"
    t.string   "asset_server"
    t.string   "title"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "application_domain"
  end

  create_table "images", :force => true do |t|
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tile_512_file_name"
    t.string   "tile_512_content_type"
    t.integer  "tile_512_file_size"
    t.datetime "tile_512_updated_at"
    t.string   "tile_256_file_name"
    t.string   "tile_256_content_type"
    t.integer  "tile_256_file_size"
    t.datetime "tile_256_updated_at"
  end

  create_table "panels", :force => true do |t|
    t.string   "arrangement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
    t.string   "tile_256_file_name"
    t.string   "tile_256_content_type"
    t.integer  "tile_256_file_size"
    t.datetime "tile_256_updated_at"
    t.string   "tile_512_file_name"
    t.string   "tile_512_content_type"
    t.integer  "tile_512_file_size"
    t.datetime "tile_512_updated_at"
    t.integer  "image_id"
    t.float    "crop_x"
    t.float    "crop_y"
    t.float    "crop_w"
    t.float    "crop_h"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.string   "panel"
    t.text     "body"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "venue_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
