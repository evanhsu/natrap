require 'rails_helper'

RSpec.describe "dandies/index", type: :view do
  before(:each) do
    assign(:dandies, [
      Dandy.create!(),
      Dandy.create!()
    ])
  end

  it "renders a list of dandies" do
    render
  end
end
