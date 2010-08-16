require 'spec_helper'

describe "venues/index.html.haml" do
  before(:each) do
    assign(:venues, [
      stub_model(Venue),
      stub_model(Venue)
    ])
  end

  it "renders a list of venues" do
    render
  end
end
