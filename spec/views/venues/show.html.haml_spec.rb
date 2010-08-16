require 'spec_helper'

describe "venues/show.html.haml" do
  before(:each) do
    @venue = assign(:venue, stub_model(Venue))
  end

  it "renders attributes in <p>" do
    render
  end
end
