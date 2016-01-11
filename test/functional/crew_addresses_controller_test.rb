require 'test_helper'

class CrewAddressesControllerTest < ActionController::TestCase
  setup do
    @crew_address = crew_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crew_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crew_address" do
    assert_difference('CrewAddress.count') do
      post :create, :crew_address => @crew_address.attributes
    end

    assert_redirected_to crew_address_path(assigns(:crew_address))
  end

  test "should show crew_address" do
    get :show, :id => @crew_address.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @crew_address.to_param
    assert_response :success
  end

  test "should update crew_address" do
    put :update, :id => @crew_address.to_param, :crew_address => @crew_address.attributes
    assert_redirected_to crew_address_path(assigns(:crew_address))
  end

  test "should destroy crew_address" do
    assert_difference('CrewAddress.count', -1) do
      delete :destroy, :id => @crew_address.to_param
    end

    assert_redirected_to crew_addresses_path
  end
end
