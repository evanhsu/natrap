require 'rails_helper'

RSpec.describe "irregularities/new", type: :view do
  before(:each) do
    assign(:irregularity, Irregularity.new(
      :author => "MyString",
      :fire_number => "MyString",
      :fire_name => "MyString",
      :tailnumber => "MyString",
      :operation_id => 1,
      :narrative => "MyString"
    ))
  end

  it "renders new irregularity form" do
    render

    assert_select "form[action=?][method=?]", irregularities_path, "post" do

      assert_select "input#irregularity_author[name=?]", "irregularity[author]"

      assert_select "input#irregularity_fire_number[name=?]", "irregularity[fire_number]"

      assert_select "input#irregularity_fire_name[name=?]", "irregularity[fire_name]"

      assert_select "input#irregularity_tailnumber[name=?]", "irregularity[tailnumber]"

      assert_select "input#irregularity_operation_id[name=?]", "irregularity[operation_id]"

      assert_select "input#irregularity_narrative[name=?]", "irregularity[narrative]"
    end
  end
end
