require 'test_helper'

class HelibasesControllerTest < ActionController::TestCase
  setup do
    @helibasis = helibases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:helibases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create helibasis" do
    assert_difference('Helibase.count') do
      post :create, :helibasis => @helibasis.attributes
    end

    assert_redirected_to helibasis_path(assigns(:helibasis))
  end

  test "should show helibasis" do
    get :show, :id => @helibasis.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @helibasis.to_param
    assert_response :success
  end

  test "should update helibasis" do
    put :update, :id => @helibasis.to_param, :helibasis => @helibasis.attributes
    assert_redirected_to helibasis_path(assigns(:helibasis))
  end

  test "should destroy helibasis" do
    assert_difference('Helibase.count', -1) do
      delete :destroy, :id => @helibasis.to_param
    end

    assert_redirected_to helibases_path
  end
end
