require 'test_helper'

class HelicoptersControllerTest < ActionController::TestCase
  setup do
    @helicopter = helicopters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:helicopters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create helicopter" do
    assert_difference('Helicopter.count') do
      post :create, :helicopter => @helicopter.attributes
    end

    assert_redirected_to helicopter_path(assigns(:helicopter))
  end

  test "should show helicopter" do
    get :show, :id => @helicopter.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @helicopter.to_param
    assert_response :success
  end

  test "should update helicopter" do
    put :update, :id => @helicopter.to_param, :helicopter => @helicopter.attributes
    assert_redirected_to helicopter_path(assigns(:helicopter))
  end

  test "should destroy helicopter" do
    assert_difference('Helicopter.count', -1) do
      delete :destroy, :id => @helicopter.to_param
    end

    assert_redirected_to helicopters_path
  end
end
