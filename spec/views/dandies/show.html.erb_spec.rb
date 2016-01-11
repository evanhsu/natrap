require 'rails_helper'

RSpec.describe "dandies/show", type: :view do
  before(:each) do
    @dandy = assign(:dandy, Dandy.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
