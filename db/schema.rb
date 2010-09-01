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

ActiveRecord::Schema.define(:version => 20100830210009) do

  create_table "brands", :force => true do |t|
    t.string   "domain_name"
    t.string   "asset_server"
    t.string   "title"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
