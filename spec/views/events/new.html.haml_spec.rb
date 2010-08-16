require 'spec_helper'

describe "events/new.html.haml" do
  before(:each) do
    assign(:event, stub_model(Event,
      :new_record? => true
    ))
  end

  it "renders new event form" do
    render

    rendered.should have_selector("form", :action => events_path, :method => "post") do |form|
    end
  end
end
