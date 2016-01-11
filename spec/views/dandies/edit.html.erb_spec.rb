require 'rails_helper'

RSpec.describe "dandies/edit", type: :view do
  before(:each) do
    @dandy = assign(:dandy, Dandy.create!())
  end

  it "renders the edit dandy form" do
    render

    assert_select "form[action=?][method=?]", dandy_path(@dandy), "post" do
    end
  end
end
