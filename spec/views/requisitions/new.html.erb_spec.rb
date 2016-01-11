require 'rails_helper'

RSpec.describe "requisitions/new", type: :view do
  before(:each) do
    assign(:requisition, Requisition.new())
  end

  it "renders new requisition form" do
    render

    assert_select "form[action=?][method=?]", requisitions_path, "post" do
    end
  end
end
