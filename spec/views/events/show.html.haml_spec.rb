require 'spec_helper'

describe "events/show.html.haml" do
  before(:each) do
    @event = assign(:event, stub_model(Event))
  end

  it "renders attributes in <p>" do
    render
  end
end
