require 'rails_helper'

RSpec.describe "irregularities/index", type: :view do
  before(:each) do
    assign(:irregularities, [
      Irregularity.create!(
        :author => "Author",
        :fire_number => "Fire Number",
        :fire_name => "Fire Name",
        :tailnumber => "Tailnumber",
        :operation_id => 1,
        :narrative => "Narrative"
      ),
      Irregularity.create!(
        :author => "Author",
        :fire_number => "Fire Number",
        :fire_name => "Fire Name",
        :tailnumber => "Tailnumber",
        :operation_id => 1,
        :narrative => "Narrative"
      )
    ])
  end

  it "renders a list of irregularities" do
    render
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => "Fire Number".to_s, :count => 2
    assert_select "tr>td", :text => "Fire Name".to_s, :count => 2
    assert_select "tr>td", :text => "Tailnumber".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Narrative".to_s, :count => 2
  end
end
