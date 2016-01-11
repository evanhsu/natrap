require 'rails_helper'

RSpec.describe "irregularities/edit", type: :view do
  before(:each) do
    @irregularity = assign(:irregularity, Irregularity.create!(
      :author => "MyString",
      :fire_number => "MyString",
      :fire_name => "MyString",
      :tailnumber => "MyString",
      :operation_id => 1,
      :narrative => "MyString"
    ))
  end

  it "renders the edit irregularity form" do
    render

    assert_select "form[action=?][method=?]", irregularity_path(@irregularity), "post" do

      assert_select "input#irregularity_author[name=?]", "irregularity[author]"

      assert_select "input#irregularity_fire_number[name=?]", "irregularity[fire_number]"

      assert_select "input#irregularity_fire_name[name=?]", "irregularity[fire_name]"

      assert_select "input#irregularity_tailnumber[name=?]", "irregularity[tailnumber]"

      assert_select "input#irregularity_operation_id[name=?]", "irregularity[operation_id]"

      assert_select "input#irregularity_narrative[name=?]", "irregularity[narrative]"
    end
  end
end
