require 'rails_helper'

RSpec.describe "irregularities/show", type: :view do
  before(:each) do
    @irregularity = assign(:irregularity, Irregularity.create!(
      :author => "Author",
      :fire_number => "Fire Number",
      :fire_name => "Fire Name",
      :tailnumber => "Tailnumber",
      :operation_id => 1,
      :narrative => "Narrative"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Author/)
    expect(rendered).to match(/Fire Number/)
    expect(rendered).to match(/Fire Name/)
    expect(rendered).to match(/Tailnumber/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Narrative/)
  end
end
