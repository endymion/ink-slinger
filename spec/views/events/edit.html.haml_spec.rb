require 'spec_helper'

describe "events/edit.html.haml" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :new_record? => false
    ))
  end

  it "renders the edit event form" do
    render

    rendered.should have_selector("form", :action => event_path(@event), :method => "post") do |form|
    end
  end
end
