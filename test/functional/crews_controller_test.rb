require 'test_helper'

class CrewsControllerTest < ActionController::TestCase
  setup do
    @crew = crews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crew" do
    assert_difference('Crew.count') do
      post :create, :crew => @crew.attributes
    end

    assert_redirected_to crew_path(assigns(:crew))
  end

  test "should show crew" do
    get :show, :id => @crew.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @crew.to_param
    assert_response :success
  end

  test "should update crew" do
    put :update, :id => @crew.to_param, :crew => @crew.attributes
    assert_redirected_to crew_path(assigns(:crew))
  end

  test "should destroy crew" do
    assert_difference('Crew.count', -1) do
      delete :destroy, :id => @crew.to_param
    end

    assert_redirected_to crews_path
  end
end
