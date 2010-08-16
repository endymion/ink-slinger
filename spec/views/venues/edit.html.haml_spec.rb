require 'spec_helper'

describe "venues/edit.html.haml" do
  before(:each) do
    @venue = assign(:venue, stub_model(Venue,
      :new_record? => false
    ))
  end

  it "renders the edit venue form" do
    render

    rendered.should have_selector("form", :action => venue_path(@venue), :method => "post") do |form|
    end
  end
end
