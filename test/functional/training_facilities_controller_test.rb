require 'test_helper'

class TrainingFacilitiesControllerTest < ActionController::TestCase
  setup do
    @training_facility = training_facilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:training_facilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create training_facility" do
    assert_difference('TrainingFacility.count') do
      post :create, :training_facility => @training_facility.attributes
    end

    assert_redirected_to training_facility_path(assigns(:training_facility))
  end

  test "should show training_facility" do
    get :show, :id => @training_facility.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @training_facility.to_param
    assert_response :success
  end

  test "should update training_facility" do
    put :update, :id => @training_facility.to_param, :training_facility => @training_facility.attributes
    assert_redirected_to training_facility_path(assigns(:training_facility))
  end

  test "should destroy training_facility" do
    assert_difference('TrainingFacility.count', -1) do
      delete :destroy, :id => @training_facility.to_param
    end

    assert_redirected_to training_facilities_path
  end
end
