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

ActiveRecord::Schema.define(version: 20151021143459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircraft_types", force: true do |t|
    t.string   "shortname"
    t.string   "fullname"
    t.string   "configuration"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cardholders", force: true do |t|
    t.integer  "crew_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cardholders", ["crew_id"], name: "index_cardholders_on_crew_id", using: :btree

  create_table "cargo_letdowns", force: true do |t|
    t.integer  "operation_id"
    t.string   "letdown_line_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificates", force: true do |t|
    t.string   "name"
    t.integer  "person_id"
    t.integer  "enrollment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "year"
  end

  create_table "cost_sheets", force: true do |t|
    t.date     "date"
    t.integer  "helicopter_id"
    t.string   "chargeCode"
    t.string   "override"
    t.string   "incidentNumber"
    t.float    "dailyAvailabilityRate"
    t.float    "pilotExtStandbyRate"
    t.float    "driverExtStandbyRate"
    t.float    "mechanicExtStandbyRate"
    t.float    "serviceTruckMileageRate"
    t.string   "hmgb"
    t.float    "dailyAvailabilityQty"
    t.float    "pilotExtStandbyQty"
    t.float    "driverExtStandbyQty"
    t.float    "mechanicExtStandbyQty"
    t.float    "serviceTruckMileageQty"
    t.float    "dailyAvailabilityTotal"
    t.float    "pilotExtStandbyTotal"
    t.float    "driverExtStandbyTotal"
    t.float    "mechanicExtStandbyTotal"
    t.float    "serviceTruckMileageTotal"
    t.float    "grandTotal"
    t.string   "additionalCostDesc"
    t.float    "additionalCostTotal"
    t.integer  "numPilots"
    t.integer  "numDrivers"
    t.integer  "numMechanics"
    t.integer  "pax"
    t.integer  "waterGallons"
    t.integer  "cargoLbs"
    t.integer  "retardantGallons"
    t.integer  "foamGallons"
    t.float    "acresTreated"
    t.integer  "psdBalls"
    t.integer  "gelGallons"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "flight_hour_rate"
    t.float    "flight_hour_qty"
    t.float    "flight_hour_total"
    t.integer  "num_ron_people"
    t.float    "ron_rate"
    t.float    "ron_total"
  end

  create_table "crew_addresses", force: true do |t|
    t.integer  "crew_id"
    t.string   "address_type"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crews", force: true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.integer  "region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.string   "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "crews_dandies", id: false, force: true do |t|
    t.integer "crew_id"
    t.integer "dandy_id"
  end

  add_index "crews_dandies", ["crew_id"], name: "index_crews_dandies_on_crew_id", using: :btree
  add_index "crews_dandies", ["dandy_id"], name: "index_crews_dandies_on_dandy_id", using: :btree

  create_table "dandies", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dandy_static_pages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dispatch_centers", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "callsign"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "phone24"
    t.string   "fax"
    t.string   "location"
    t.string   "fscoverage"
    t.string   "blmcoverage"
    t.string   "parkcoverage"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", force: true do |t|
    t.integer  "person_id"
    t.integer  "scheduled_course_id"
    t.string   "status",               default: "nominated"
    t.float    "cost_tuition",         default: 0.0
    t.float    "cost_wages",           default: 0.0
    t.boolean  "prework_received",     default: false
    t.string   "payment_method"
    t.string   "charge_code"
    t.string   "override"
    t.boolean  "travel_paid",          default: false
    t.float    "cost_travel",          default: 0.0
    t.float    "cost_misc",            default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "course_name"
    t.boolean  "certificate_received", default: false
  end

  create_table "frequencies", force: true do |t|
    t.integer  "frequency_group_id"
    t.integer  "channel"
    t.string   "name"
    t.string   "rx"
    t.string   "rx_tone"
    t.string   "tx"
    t.string   "tx_tone"
    t.string   "band"
    t.string   "repeater_location"
    t.string   "coverage_area"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frequency_groups", force: true do |t|
    t.string   "name"
    t.integer  "dispatchcenter_id"
    t.string   "group_number"
    t.integer  "crew_id"
    t.integer  "dandy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helibases", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.float    "lat_degrees"
    t.float    "lon_degrees"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crew_id"
    t.string   "street"
    t.string   "state"
    t.string   "zip"
    t.string   "main_phone"
    t.string   "fax"
    t.string   "airport_identifier"
    t.string   "elevation"
    t.float    "lat_minutes"
    t.float    "lon_minutes"
    t.string   "nearest_airport_name"
    t.string   "nearest_airport_identifier"
    t.string   "nearest_airport_elevation"
    t.string   "department1_title"
    t.string   "department1_contact_name"
    t.string   "department1_phone"
    t.string   "department2_title"
    t.string   "department2_contact_name"
    t.string   "department2_phone"
    t.string   "department3_title"
    t.string   "department3_contact_name"
    t.string   "department3_phone"
    t.string   "base_manager_name"
    t.string   "base_manager_phone"
    t.string   "airport_name"
  end

  create_table "helicopters", force: true do |t|
    t.string   "tailnumber"
    t.string   "model"
    t.integer  "type_class"
    t.string   "contractType"
    t.float    "flightRate"
    t.float    "dailyAvailabilityRate"
    t.float    "pilotExtStandbyRate"
    t.float    "driverExtStandbyRate"
    t.float    "mechanicExtStandbyRate"
    t.float    "serviceTruckMileageRate"
    t.string   "hmgb"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "helibase_id"
  end

  create_table "hotels", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "crew_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incident_rosters", force: true do |t|
    t.integer  "incident_id"
    t.string   "role"
    t.string   "qt"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidents", force: true do |t|
    t.string   "number"
    t.date     "date"
    t.string   "event_type"
    t.string   "name"
    t.string   "charge_code"
    t.string   "override"
    t.integer  "acres"
    t.string   "fuel_models"
    t.text     "description"
    t.string   "g_cal_event_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "complexity"
  end

  create_table "irregularities", force: true do |t|
    t.date     "date"
    t.string   "author"
    t.string   "fire_number"
    t.string   "fire_name"
    t.string   "tailnumber"
    t.integer  "operation_id"
    t.string   "narrative"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "items", force: true do |t|
    t.string   "serial_number"
    t.string   "type"
    t.string   "category"
    t.string   "color"
    t.string   "size"
    t.string   "description"
    t.string   "condition"
    t.string   "comments"
    t.integer  "crew_id"
    t.string   "status"
    t.string   "use_offset"
    t.date     "in_service_date"
    t.date     "retired_date"
    t.string   "retired_category"
    t.string   "retired_reason"
    t.decimal  "quantity"
    t.decimal  "restock_trigger"
    t.decimal  "restock_to_level"
    t.text     "item_source"
    t.integer  "checked_out_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entries", force: true do |t|
    t.integer  "person_id"
    t.integer  "instance_id"
    t.string   "model_name"
    t.string   "action"
    t.string   "attribute_name"
    t.string   "old_value"
    t.string   "new_value"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operations", force: true do |t|
    t.string   "aircraft_type_id"
    t.string   "aircraft_tailnumber"
    t.integer  "pilot_id"
    t.string   "weather"
    t.integer  "height"
    t.integer  "canopy_opening"
    t.date     "date"
    t.string   "location"
    t.string   "operation_type"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "incident_number"
    t.integer  "creator_id"
  end

  create_table "people", force: true do |t|
    t.string   "iqcs_num"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "headshot_file_name"
    t.boolean  "has_purchase_card"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "account_type"
    t.datetime "last_login"
    t.string   "authorizations"
    t.string   "headshot_content_type"
    t.string   "headshot_file_size"
    t.datetime "headshot_updated_at"
    t.integer  "account_crew_id"
  end

  create_table "person_addresses", force: true do |t|
    t.integer  "person_id"
    t.string   "address_type"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notify"
  end

  create_table "pilots", force: true do |t|
    t.integer  "person_id"
    t.string   "vendor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualifications", force: true do |t|
    t.string   "acronym"
    t.boolean  "trainee"
    t.string   "description"
    t.date     "date_initiated"
    t.date     "date_qualified"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.datetime "document_updated_at"
  end

  create_table "rappel_spotters", force: true do |t|
    t.integer  "person_id"
    t.integer  "operational_offset"
    t.integer  "proficiency_offset"
    t.integer  "rookie_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rappellers", force: true do |t|
    t.integer  "person_id"
    t.integer  "operational_offset"
    t.integer  "proficiency_offset"
    t.integer  "rookie_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rappels", force: true do |t|
    t.integer  "operation_id"
    t.integer  "rappeller_id"
    t.string   "door"
    t.integer  "stick"
    t.string   "rope_end"
    t.boolean  "knot"
    t.boolean  "eto"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rope_number"
    t.string   "descent_device_number"
    t.string   "purpose"
    t.integer  "confirmer_id"
  end

  create_table "requisition_line_items", force: true do |t|
    t.integer  "requisition_id"
    t.text     "s_number"
    t.text     "charge_code"
    t.text     "override"
    t.decimal  "amount",         precision: 7, scale: 2
    t.boolean  "received",                               default: false
    t.boolean  "reconciled",                             default: false
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requisition_line_items", ["requisition_id"], name: "index_requisition_line_items_on_requisition_id", using: :btree

  create_table "requisitions", force: true do |t|
    t.integer  "crew_id"
    t.text     "vendor_info"
    t.text     "description"
    t.decimal  "amount",                   precision: 7, scale: 2
    t.date     "date"
    t.text     "cardholder"
    t.text     "comments"
    t.string   "attachment1_file_name"
    t.string   "attachment1_content_type"
    t.integer  "attachment1_file_size"
    t.datetime "attachment1_updated_at"
    t.string   "attachment2_file_name"
    t.string   "attachment2_content_type"
    t.integer  "attachment2_file_size"
    t.datetime "attachment2_updated_at"
    t.string   "attachment3_file_name"
    t.string   "attachment3_content_type"
    t.integer  "attachment3_file_size"
    t.datetime "attachment3_updated_at"
    t.text     "modified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requisitions", ["crew_id"], name: "index_requisitions_on_crew_id", using: :btree

  create_table "ro_bo_positions", force: true do |t|
    t.integer  "roBoStateId"
    t.integer  "personId"
    t.string   "role"
    t.string   "rank"
    t.integer  "cellIndex"
    t.string   "listId"
    t.integer  "row"
    t.integer  "col"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "person_name"
    t.string   "person_quals"
    t.string   "person_headshot_url"
  end

  create_table "ro_bo_states", force: true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crew_id"
    t.string   "change_type"
    t.integer  "changed_person_id"
  end

  create_table "rostered_people", force: true do |t|
    t.integer  "roster_id"
    t.integer  "person_id"
    t.string   "role"
    t.string   "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rosters", force: true do |t|
    t.integer  "crew_id"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scheduled_courses", force: true do |t|
    t.date     "date_start"
    t.date     "date_end"
    t.string   "location"
    t.integer  "training_facility_id"
    t.string   "name"
    t.string   "g_cal_event_url"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crew_id"
  end

  create_table "spots", force: true do |t|
    t.integer  "operation_id"
    t.integer  "rappel_spotter_id"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "confirmer_id"
  end

  create_table "staffing_levels", force: true do |t|
    t.integer  "crew_id"
    t.string   "training_needs"
    t.string   "resource_1_name"
    t.string   "resource_1_detail"
    t.string   "resource_1_location"
    t.string   "resource_1_hrap_surplus"
    t.string   "resource_1_status"
    t.string   "resource_1_comment"
    t.string   "resource_1_contract_end_date"
    t.string   "resource_2_name"
    t.string   "resource_2_detail"
    t.string   "resource_2_location"
    t.string   "resource_2_hrap_surplus"
    t.string   "resource_2_status"
    t.string   "resource_2_comment"
    t.string   "resource_2_contract_end_date"
    t.string   "resource_3_name"
    t.string   "resource_3_detail"
    t.string   "resource_3_location"
    t.string   "resource_3_hrap_surplus"
    t.string   "resource_3_status"
    t.string   "resource_3_comment"
    t.string   "resource_3_contract_end_date"
    t.string   "resource_4_name"
    t.string   "resource_4_detail"
    t.string   "resource_4_location"
    t.string   "resource_4_hrap_surplus"
    t.string   "resource_4_status"
    t.string   "resource_4_comment"
    t.string   "resource_4_contract_end_date"
    t.string   "resource_5_name"
    t.string   "resource_5_detail"
    t.string   "resource_5_location"
    t.string   "resource_5_hrap_surplus"
    t.string   "resource_5_status"
    t.string   "resource_5_comment"
    t.string   "resource_5_contract_end_date"
    t.string   "resource_6_name"
    t.string   "resource_6_detail"
    t.string   "resource_6_location"
    t.string   "resource_6_hrap_surplus"
    t.string   "resource_6_status"
    t.string   "resource_6_comment"
    t.string   "resource_6_contract_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_facilities", force: true do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.integer  "crew_id"
  end

  create_table "training_priorities", force: true do |t|
    t.integer  "priority"
    t.string   "name"
    t.integer  "crew_id"
    t.string   "qualification"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
