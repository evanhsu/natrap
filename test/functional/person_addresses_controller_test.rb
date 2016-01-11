require 'test_helper'

class PersonAddressesControllerTest < ActionController::TestCase
  setup do
    @person_address = person_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_address" do
    assert_difference('PersonAddress.count') do
      post :create, :person_address => @person_address.attributes
    end

    assert_redirected_to person_address_path(assigns(:person_address))
  end

  test "should show person_address" do
    get :show, :id => @person_address.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @person_address.to_param
    assert_response :success
  end

  test "should update person_address" do
    put :update, :id => @person_address.to_param, :person_address => @person_address.attributes
    assert_redirected_to person_address_path(assigns(:person_address))
  end

  test "should destroy person_address" do
    assert_difference('PersonAddress.count', -1) do
      delete :destroy, :id => @person_address.to_param
    end

    assert_redirected_to person_addresses_path
  end
end
