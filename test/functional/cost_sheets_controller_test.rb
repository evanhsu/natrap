require 'test_helper'

class CostSheetsControllerTest < ActionController::TestCase
  setup do
    @cost_sheet = cost_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cost_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cost_sheet" do
    assert_difference('CostSheet.count') do
      post :create, :cost_sheet => @cost_sheet.attributes
    end

    assert_redirected_to cost_sheet_path(assigns(:cost_sheet))
  end

  test "should show cost_sheet" do
    get :show, :id => @cost_sheet.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cost_sheet.to_param
    assert_response :success
  end

  test "should update cost_sheet" do
    put :update, :id => @cost_sheet.to_param, :cost_sheet => @cost_sheet.attributes
    assert_redirected_to cost_sheet_path(assigns(:cost_sheet))
  end

  test "should destroy cost_sheet" do
    assert_difference('CostSheet.count', -1) do
      delete :destroy, :id => @cost_sheet.to_param
    end

    assert_redirected_to cost_sheets_path
  end
end
