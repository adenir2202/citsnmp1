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

ActiveRecord::Schema.define(version: 20130722185810) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "author_name"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"

  create_table "hosts", force: true do |t|
    t.string   "hostName",       limit: 250, default: "localhost", null: false
    t.string   "description",                default: "null"
    t.string   "snmp_community", limit: 100, default: "null"
    t.integer  "snmp_version",   limit: 2,   default: 1,           null: false
    t.string   "snmp_userName",  limit: 50,  default: "null"
    t.string   "snmp_password",  limit: 50,  default: "null"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snmp_queries", force: true do |t|
    t.string   "OID",         limit: 64,    default: "new hash", null: false
    t.string   "name",        limit: 100,   default: "new_col",  null: false
    t.string   "text",        limit: 32760, default: "x",        null: false
    t.string   "xml",         limit: 32760, default: "<>",       null: false
    t.string   "description",               default: "null"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snmpsrvs", force: true do |t|
    t.string   "OID"
    t.text     "OID_name"
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["article_id"], name: "index_taggings_on_article_id"
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
