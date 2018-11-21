require 'rails_helper'

RSpec.describe "options/edit", type: :view do
  before(:each) do
    @option = assign(:option, Option.create!(
      :label => "MyString",
      :list_id => 1
    ))
  end

  it "renders the edit option form" do
    render

    assert_select "form[action=?][method=?]", option_path(@option), "post" do

      assert_select "input[name=?]", "option[label]"

      assert_select "input[name=?]", "option[list_id]"
    end
  end
end
