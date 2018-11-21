require 'rails_helper'

RSpec.describe "options/index", type: :view do
  before(:each) do
    assign(:options, [
      Option.create!(
        :label => "Label",
        :list_id => 2
      ),
      Option.create!(
        :label => "Label",
        :list_id => 2
      )
    ])
  end

  it "renders a list of options" do
    render
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
