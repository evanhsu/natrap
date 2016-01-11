require 'rails_helper'

RSpec.describe "requisitions/edit", type: :view do
  before(:each) do
    @requisition = assign(:requisition, Requisition.create!())
  end

  it "renders the edit requisition form" do
    render

    assert_select "form[action=?][method=?]", requisition_path(@requisition), "post" do
    end
  end
end
