require 'spec_helper'

describe "venues/new.html.haml" do
  before(:each) do
    assign(:venue, stub_model(Venue,
      :new_record? => true
    ))
  end

  it "renders new venue form" do
    render

    rendered.should have_selector("form", :action => venues_path, :method => "post") do |form|
    end
  end
end
