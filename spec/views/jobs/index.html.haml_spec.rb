require 'spec_helper'

describe "jobs/index.html.haml" do
  before(:each) do
    assign(:jobs, [
      stub_model(Job),
      stub_model(Job)
    ])
  end

  it "renders a list of jobs" do
    render
  end
end
