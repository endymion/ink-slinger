require 'spec_helper'

describe "topics/index.html.haml" do
  before(:each) do
    @topics = [stub_model(Topic), stub_model(Topic)].paginate :page => 1, :per_page => 2 
    assigns[:topics] = @topics
  end

  it "renders a list of topics" do
    render
  end
end
