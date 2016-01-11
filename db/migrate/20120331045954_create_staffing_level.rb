class CreateStaffingLevel < ActiveRecord::Migration
  def self.up
    create_table :staffing_levels do |t|
      t.integer     :crew_id
      t.string      :training_needs
      t.string      :resource_1_name
      t.string      :resource_1_detail
      t.string      :resource_1_location
      t.string      :resource_1_hrap_surplus
      t.string      :resource_1_status
      t.string      :resource_1_comment
      t.string      :resource_1_contract_end_date
      t.string      :resource_2_name
      t.string      :resource_2_detail
      t.string      :resource_2_location
      t.string      :resource_2_hrap_surplus
      t.string      :resource_2_status
      t.string      :resource_2_comment
      t.string      :resource_2_contract_end_date
      t.string      :resource_3_name
      t.string      :resource_3_detail
      t.string      :resource_3_location
      t.string      :resource_3_hrap_surplus
      t.string      :resource_3_status
      t.string      :resource_3_comment
      t.string      :resource_3_contract_end_date
      t.string      :resource_4_name
      t.string      :resource_4_detail
      t.string      :resource_4_location
      t.string      :resource_4_hrap_surplus
      t.string      :resource_4_status
      t.string      :resource_4_comment
      t.string      :resource_4_contract_end_date
      t.string      :resource_5_name
      t.string      :resource_5_detail
      t.string      :resource_5_location
      t.string      :resource_5_hrap_surplus
      t.string      :resource_5_status
      t.string      :resource_5_comment
      t.string      :resource_5_contract_end_date
      t.string      :resource_6_name
      t.string      :resource_6_detail
      t.string      :resource_6_location
      t.string      :resource_6_hrap_surplus
      t.string      :resource_6_status
      t.string      :resource_6_comment
      t.string      :resource_6_contract_end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :staffing_levels
  end
end
