require 'spec_helper'

describe "topics/index.html.haml" do
  before(:each) do
    assign(:topics, [
      stub_model(Topic),
      stub_model(Topic)
    ])
    assigns[:topics].stub!(:total_pages).and_return(0)
  end

  it "renders a list of topics" do
    render
  end
end
