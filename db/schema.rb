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

ActiveRecord::Schema.define(version: 20190523134316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.index ["token"], name: "index_ahoy_messages_on_token", using: :btree
    t.index ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "preview_text"
    t.text     "body"
    t.string   "author"
    t.datetime "available_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "hero_image_file_name"
    t.string   "hero_image_content_type"
    t.integer  "hero_image_file_size"
    t.datetime "hero_image_updated_at"
  end

  create_table "challenges", force: :cascade do |t|
    t.string   "category"
    t.string   "name"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "promo_image_file_name"
    t.string   "promo_image_content_type"
    t.integer  "promo_image_file_size"
    t.datetime "promo_image_updated_at"
  end

  create_table "coaches", force: :cascade do |t|
    t.string   "name"
    t.string   "bio"
    t.integer  "display_order"
    t.string   "instagram_link"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "email"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.string   "link"
    t.string   "short_description"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "first_name"
  end

  create_table "event_discount_codes", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "discount_code",         default: 0
    t.string   "word"
    t.boolean  "is_available",          default: true
    t.integer  "usage_cap",             default: 10
    t.integer  "times_used",            default: 0
    t.integer  "percentage_as_integer", default: 10
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["event_id"], name: "index_event_discount_codes_on_event_id", using: :btree
  end

  create_table "event_stages", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.integer  "cap_size"
    t.datetime "starting_time"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "registrations_count", default: 0
    t.index ["event_id"], name: "index_event_stages_on_event_id", using: :btree
  end

  create_table "event_teams", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "stripe_customer_id"
    t.string   "stripe_charge_id"
    t.string   "division"
    t.string   "receipt_email"
    t.string   "contact_phone"
    t.index ["event_id"], name: "index_event_teams_on_event_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "description"
    t.string   "link"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "promo_image_file_name"
    t.string   "promo_image_content_type"
    t.integer  "promo_image_file_size"
    t.datetime "promo_image_updated_at"
    t.string   "address"
    t.string   "button_text"
    t.boolean  "registerable",              default: false
    t.datetime "registration_ends_at"
    t.string   "slug"
    t.text     "registration_instructions"
    t.boolean  "is_free",                   default: true
    t.integer  "cap_size",                  default: 50
    t.integer  "price_in_cents"
    t.boolean  "is_team_registration"
    t.boolean  "is_offering_shirt",         default: true
    t.integer  "team_price_in_cents"
    t.boolean  "allows_teams",              default: false
    t.string   "team_instructions"
    t.boolean  "allows_solo",               default: true
  end

  create_table "participants", force: :cascade do |t|
    t.string   "name"
    t.string   "mobile_phone"
    t.integer  "submissions_count"
    t.boolean  "is_active",         default: true
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "pricing_options", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "amount_in_cents"
    t.string   "subtype"
    t.integer  "display_order"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "display_order"
    t.string   "text"
    t.text     "answer"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.boolean  "is_paid"
    t.string   "phone"
    t.string   "email"
    t.string   "stripe_customer_id"
    t.string   "stripe_charge_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "event_stage_id"
    t.string   "primary_shirt_size"
    t.integer  "event_team_id"
    t.string   "discount_code"
    t.string   "chosen_gender"
    t.index ["event_id"], name: "index_registrations_on_event_id", using: :btree
    t.index ["event_stage_id"], name: "index_registrations_on_event_stage_id", using: :btree
    t.index ["event_team_id"], name: "index_registrations_on_event_team_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "studio_session_types", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "promo_video_url"
    t.boolean  "active"
    t.string   "slug"
    t.integer  "display_order"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "promo_image_file_name"
    t.string   "promo_image_content_type"
    t.integer  "promo_image_file_size"
    t.datetime "promo_image_updated_at"
    t.string   "link"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "participant_id"
    t.string   "from_number"
    t.string   "message_body"
    t.integer  "parsed_meters"
    t.string   "parsed_name"
    t.boolean  "is_valid",         default: true
    t.boolean  "is_rejected",      default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "twilio_sid"
    t.string   "response_text"
    t.string   "rejection_reason"
    t.index ["participant_id"], name: "index_submissions_on_participant_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "admin_role",             default: false
    t.boolean  "supervisor_role",        default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invitations_count",      default: 0
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "deleted_at"
    t.string   "timezone",               default: "Pacific Time (US & Canada)"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

  add_foreign_key "event_discount_codes", "events"
  add_foreign_key "event_stages", "events"
  add_foreign_key "event_teams", "events"
  add_foreign_key "registrations", "event_stages"
  add_foreign_key "registrations", "event_teams"
  add_foreign_key "registrations", "events"
  add_foreign_key "submissions", "participants"
end
