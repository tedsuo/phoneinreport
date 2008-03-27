# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 3) do

  create_table "campaigns", :force => true do |t|
    t.string   "event_feed_url"
    t.string   "pop_server"
    t.string   "pop_user"
    t.string   "pop_pw"
    t.integer  "pop_port"
    t.string   "s3_bucket"
    t.string   "s3_key"
    t.string   "s3_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "event_id"
    t.integer  "campaign_id"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone"
    t.string   "phone_city"
    t.string   "phone_state"
    t.string   "file_status"
    t.string   "file_wav_url"
    t.string   "file_mp3_url"
    t.integer  "length"
    t.string   "reporter_name"
    t.string   "reporter_email"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "campaign_id"
    t.string   "password"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end