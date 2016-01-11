require 'rails_helper'

RSpec.describe "requisitions/show", type: :view do
  before(:each) do
    @requisition = assign(:requisition, Requisition.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
