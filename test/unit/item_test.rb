require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  def setup
    @accountable_item = items(:accountable_item)
    @bulk_item = items(:bulk_item)
    @rappel_rope_in_service1 = items(:rappel_rope_in_service1)
    @rappel_rope_in_service2 = items(:rappel_rope_in_service2)
    @rappel_rope_retired = items(:rappel_rope_retired)
    @descent_device_in_service = items(:descent_device_in_service)
    @descent_device_retired = items(:descent_device_retired)
    @letdown_line_in_service = items(:letdown_line_in_service)
    @rappel_harness_in_service = items(:rappel_harness_in_service)

    @person = people(:dan_quinones)
  end

  test "generic Item validations with an AccountableItem" do
    i = @accountable_item
    assert_not_nil i, "Couldn't retrieve an Item from the fixture (check the items fixture for data)"
    assert i.save, "The Item in the fixture failed to save. Check the items fixture for validity (:accountable_item)."
    i.type = nil
    assert !i.save, "Saved an Item without a 'type'."
    i.type = "AccountableItem"
    assert i.save, "Item failed to save despite a valid 'type'."

    i.category = nil
    assert !i.save, "Item saved without a 'category'."
    i.category = ""
    assert !i.save, "Item saved with blank string for a 'category'."
    i.category = "    "
    assert !i.save, "Item saved with '    ' for a 'category'."
    i.category = "Sleeping Bag"
    assert i.save, "Item failed to save despite a valid 'category'."

    i.crew_id = nil
    assert !i.save, "Item saved without a crew_id."
    i.crew_id = 999 #Non-existent crew id
    assert !i.save, "Item saved with an invalid crew_id (crew doesn't exist, id:999)."
    i.crew_id = 1
    assert i.save, "Item failed to save despite a valid crew_id (crew_id: 1)."

    i.checked_out_to_id = nil
    assert i.save, "Item failed to save with a nil 'checked_out_to' id."
    i.checked_out_to = @person
    assert i.save, "Item failed to save with a valid 'checked_out_to' id (checked_out_to Dan Quinones, id:1)."
    i.checked_out_to_id = 9999 #invalid (non-existent) person.id
    assert !i.save, "Item saved with an invalid 'checked_out_to_id' (person doesn't exist, id:9999)."
  end

  test "creating a new RappelEquipment object" do
    r = RappelEquipment.new
    assert_not_nil r, "Failed to create a new blank RappelEquipment"
    assert (r.type == "RappelEquipment"), "Newly created RappelEquipment object has a 'type' other than 'RappelEquipment'"
  end

  test "creating a new AccountableItem object" do
    a = AccountableItem.new
    assert_not_nil a, "Failed to create a new blank AccountableItem"
    assert (a.type == "AccountableItem"), "Newly created AccountableItem object has a 'type' other than 'AccountableItem'"
  end

  test "creating a new BulkItem object" do
    a = BulkItem.new
    assert_not_nil a, "Failed to create a new blank BulkItem"
    assert (a.type == "BulkItem"), "Newly created BulkItem object has a 'type' other than 'BulkItem'"
    assert (a.quantity == 0), "Default 'quantity' for a new BulkItem is incorrect (#{a.quantity} instead of 0)."
    assert (a.restock_to_level == 0), "Default 'restock_to_level' for a new BulkItem is incorrect (#{a.restock_to_level} instead of 0)."
    assert (a.restock_trigger == 0), "Default 'restock_trigger' for a new BulkItem is incorrect (#{a.restock_trigger} instead of 0)."

    b = BulkItem.new({:crew_id => 1, :category => "Batteries", :quantity => 25, :restock_to_level => 30, :restock_trigger => 5})
    assert !b.nil?, "BulkItem.create failed with default values."
    assert (b.crew_id == 1), "BulkItem.create did not set the specified 'crew_id' (#{b.crew_id} instead of 1)."
    assert (b.category == "Batteries"), "BulkItem.create did not set the specified 'category' (#{b.category} instead of 'Batteries')."
    assert (b.quantity == 25), "BulkItem.create did not set the specified 'quantity' (#{b.quantity} instead of 25)."
    assert (b.restock_to_level == 30), "BulkItem.create did not set the specified 'restock_to_level' (#{b.restock_to_level} instead of 30)."
    assert (b.restock_trigger == 5), "BulkItem.create did not set the specified 'restock_trigger' (#{b.restock_trigger} instead of 5)."
  end

  test "numericality of quantities for BulkItem" do
    b = @bulk_item
    assert_not_nil b, "Couldn't retrieve a BulkItem (check the items fixture for BulkItem data)"
    assert b.save, "The BulkItem in the fixture failed to save. Check the items fixture for validity (:bulk_item)."
    b.quantity = nil
  end

  test "use_offset values for RappelEquipment items in the 'rope' category" do
    e = @rappel_rope_in_service1
    assert_not_nil e, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert e.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:rappel_rope_in_service1)."
    e.use_offset = nil
    assert e.save, "RappelEquipment Rope failed to save with a nil 'use_offset'."
    assert (e.use_offset == 'a0b0'), "RappelEquipment Rope incorrectly formatted a nil 'use_offset' before saving."
    e.use_offset = 0
    assert e.save, "RappelEquipment Rope failed to save with a 'use_offset' of 0 (zero)."
    assert (e.use_offset == 'a0b0'), "RappelEquipment Rope incorrectly formatted a 'use_offset' of 0 (zero) before saving."
    e.use_offset = 5
    assert !e.save, "RappelEquipment Rope saved with an invalid 'use_offset' (use_offset = 5)."
    e.use_offset = ""
    assert e.save, "RappelEquipment Rope failed to save with a blank string 'use_offset' (should convert to 'a0b0' then save)."
    assert (e.use_offset == 'a0b0'), "RappelEquipment Rope did not convert a blank string 'use_offset' to 'a0b0' before saving."
    e.use_offset = "a32b44b32"
    assert !e.save, "RappelEquipment Rope saved with an invalid 'use_offset' (use_offset = 'a32b44b32')."
    e.use_offset = "a43b39"
    assert e.save, "RappelEquipment Rope failed to save despite a valid 'use_offset' ('a43b39')."
  end

  test "use_offset values for RappelEquipment items in the 'letdown_line' category" do
    e = @letdown_line_in_service
    assert_not_nil e, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert e.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:letdown_line_in_service)."
    e.use_offset = nil
    assert e.save, "RappelEquipment Rope failed to save with a nil 'use_offset'."
    assert (e.use_offset == 'a0b0'), "RappelEquipment letdown_line incorrectly formatted a nil 'use_offset' before saving."
    e.use_offset = 0
    assert e.save, "RappelEquipment letdown_line failed to save with a 'use_offset' of 0 (zero)."
    assert (e.use_offset == 'a0b0'), "RappelEquipment letdown_line incorrectly formatted a 'use_offset' of 0 (zero) before saving."
    e.use_offset = 5
    assert !e.save, "RappelEquipment letdown_line saved with an invalid 'use_offset' (use_offset = 5)."
    e.use_offset = ""
    assert e.save, "RappelEquipment letdown_line failed to save with a blank string 'use_offset' (should convert to 'a0b0' then save)."
    assert (e.use_offset == 'a0b0'), "RappelEquipment letdown_line did not convert a blank string 'use_offset' to 'a0b0' before saving."
    e.use_offset = "a32b44b32"
    assert !e.save, "RappelEquipment letdown_line saved with an invalid 'use_offset' (use_offset = 'a32b44b32')."
    e.use_offset = "a43b39"
    assert e.save, "RappelEquipment letdown_line failed to save despite a valid 'use_offset' ('a43b39')."
  end

  test "use_offset values for RappelEquipment items in the 'descent_device' category" do
    e = @descent_device_in_service
    assert_not_nil e, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert e.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:descent_device_in_service)."
    e.use_offset = nil
    assert e.save, "RappelEquipment descent_device failed to save with a nil use_offset (should convert to 0, then save)."
    assert (e.use_offset == 0), "RappelEquipment descent_device did not convert a nil 'use_offset' to 0 (zero) before saving."
    e.use_offset = ""
    assert e.save, "RappelEquipment descent_device failed to save with a blank string use_offset (should convert to 0, then save)."
    assert (e.use_offset == 0), "RappelEquipment descent_device did not convert a blank string 'use_offset' to 0 (zero) before saving."
    e.use_offset = "abc"
    assert !e.save, "RappelEquipment descent_device saved with an invalid 'use_offset' ('abc')."
    e.use_offset = "4a"
    assert !e.save, "RappelEquipment descent_device saved with an invalid 'use_offset' ('4a')."
    e.use_offset = "a4"
    assert !e.save, "RappelEquipment descent_device saved with an invalid 'use_offset' ('a4')."
  end

  test "RappelEquipment serial number validations" do
    assert_not_equal RappelEquipment.all, [], "items fixture needs to have some RappelEquipment for this test to continue"
    e = @rappel_rope_in_service1
    assert_not_nil e, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert e.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:rappel_rope_in_service1)."
    e.serial_number = nil
    assert !e.save, "RappelEquipment saved without a serial number"
    e.serial_number = "1234"
    assert !e.save, "RappelEquipment saved with an improper serial number (1234)"
    e.serial_number = "abcd"
    assert !e.save, "RappelEquipment saved with an improper serial number (abcde)"
    e.serial_number = "abc-2"
    assert !e.save, "RappelEquipment saved with an improper serial number (abc-2)"
    e.serial_number = "abc-123"
    assert e.save, "RappelEquipment DID NOT save despite a valid serial number (abc-123)"

    f = @rappel_rope_in_service2
    assert_not_nil f, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert f.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:rappel_rope_in_service2)."
    f.serial_number = e.serial_number
    assert !f.save, "Item saved with a non-unique 'serial_number' in the 'category' scope."

    f = @descent_device_in_service
    assert_not_nil f, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert f.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:descent_device_in_service)."
    f.serial_number = e.serial_number
    assert f.save, "RappelEquipment failed to save with a serial number that is in-use within a different 'category'."
  end

  test "RappelEquipment category validations" do
    e = @rappel_rope_in_service1
    assert_not_nil e, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert e.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:rappel_rope_in_service1)."
    e.category = nil
    assert !e.save, "Saved a RappelEquipment with no 'category'."
    e.category = ""
    assert !e.save, "Saved a RappelEquipment with a blank string for a 'category'."
    e.category = "   "
    assert !e.save, "Saved a RappelEquipment with '   ' for a 'category'."
    e.category = "rope"
    assert e.save, "Failed to save a RappelEquipment Rope despite a valid 'category'."
  end

  test "RappelEquipment status validations" do
    e = @rappel_rope_in_service1
    assert_not_nil e, "Couldn't retrieve any RappelEquipment (check the items fixture for RappelEquipment data)"
    assert e.save, "The RappelEquipment in the fixture failed to save. Check the items fixture for validity (:rappel_rope_in_service1)."
    e.status = nil
    assert !e.save, "RappelEquipment saved without a 'status'."
    e.status = ""
    assert !e.save, "RappelEquipment saved with an empty string for a 'status'."
    e.status = "arbitrary_invalid_status"
    assert !e.save, "RappelEquipment saved with an invalid 'status'."
    e.status = "in-service"
    assert e.save, "RappelEquipment failed to save despite a valid 'status'."
  end

  test "RappelEquipment retirement validations" do
    e = @descent_device_in_service
    assert e.save, "Loaded an invalid object from the items fixture (:descent_device_in_service)."
    e.status = "retired"
    assert !e.save, "Saved a RappelEquipment item as 'retired' without any retirement details."

    e = @descent_device_retired
    assert e.save, "Loaded an invalid object from the items fixture (:descent_device_retired)."
    e.retired_reason = nil
    assert !e.save, "Saved a retired RappelEquipment with no 'retired_reason'."
    e.retired_reason = "Deep groove on the genie shaft."
    assert e.save, "Failed to save a retired RappelEquipment with a valid 'retired_reason'."
    e.retired_category = nil
    assert !e.save, "Saved a retired RappelEquipment with no 'retired_category'."
    e.retired_category = "arbitrary_invalid_category"
    assert !e.save, "Saved a retired RappelEquipment with an invalid 'retired_category'."
    e.retired_category = "field_damage"
    assert e.save, "Failed to save a retired RappelEquipment with a valid 'retired_category'."
    e.retired_date = nil
    assert !e.save, "Saved a retired RappelEquipment with no 'retired_date'."
    e.retired_date = Date.today
    assert e.save, "Failed to save a retired RappelEquipment with a valid 'retired_date'."
    e.status = "in-service"
    assert e.save, "Failed to save a RappelEquipment after changing status from retired to in-service."
    assert (e.retired_reason == nil), "RappelEquipment.retired_reason was not cleared when status changed from 'retired'."
    assert (e.retired_category == nil), "RappelEquipment.retired_category was not cleared when status changed from 'retired'."
    assert (e.retired_date == nil), "RappelEquipment.retired_date was not cleared when status changed from 'retired'."

    e = @descent_device_retired
    assert e.save, "Loaded an invalid object from the items fixture (:descent_device_retired)."
    e.status = "in-service"
    e.retired_category = "arbitrary_invalid_category"
    assert e.save, "Failed to save a RappelEquipment after changing status from retired to in-service with an invalid 'retired_category'. Ensure that retirement validations are not acting on non-retired RappelEquipment."
  end
end
