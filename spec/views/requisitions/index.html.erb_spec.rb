require 'rails_helper'

RSpec.describe "requisitions/index", type: :view do
  before(:each) do
    assign(:requisitions, [
      Requisition.create!(),
      Requisition.create!()
    ])
  end

  it "renders a list of requisitions" do
    render
  end
end
