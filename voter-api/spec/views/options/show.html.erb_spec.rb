require 'rails_helper'

RSpec.describe "options/show", type: :view do
  before(:each) do
    @option = assign(:option, Option.create!(
      :label => "Label",
      :list_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/2/)
  end
end
