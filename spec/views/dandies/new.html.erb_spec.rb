require 'rails_helper'

RSpec.describe "dandies/new", type: :view do
  before(:each) do
    assign(:dandy, Dandy.new())
  end

  it "renders new dandy form" do
    render

    assert_select "form[action=?][method=?]", dandies_path, "post" do
    end
  end
end
