require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TopicsHelper. For example:
#
# describe TopicsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe TopicsHelper do

  it "new_image should create a new Image for a Topic" do
    topic = Topic.new
    topic.images.size.should == 0
    helper.new_image(topic)
    topic.images.size.should == 1
  end
  
  it "new_panel should create a new Panel for a Topic" do
    topic = Topic.new
    topic.panels.size.should == 0
    helper.new_panel(topic)
    topic.panels.size.should == 1    
  end

  it "new_panel should not create a new Panel for a Topic if one already exists" do
    topic = Topic.new
    helper.new_panel(topic)
    topic.panels.size.should == 1    
    helper.new_panel(topic)
    topic.panels.size.should == 1    
  end

  it "id_or_new_count should return '-[id]' when given an object" do
    topic = double('Topic')
    topic.stub(:object_id).and_return(37)
    helper.id_or_new_count(topic).should == '-37'
  end

  it "id_or_new_count should return '-new-1' when given a new object" do
    topic = double('Topic')
    topic.stub(:object_id).and_return(nil)
    helper.id_or_new_count(topic).should == '-new-1'
  end

  it "id_or_new_count should increment the '-new-?' count when given another new object" do
    topic = double('Topic')
    topic.stub(:object_id).and_return(nil)
    helper.id_or_new_count(topic).should == '-new-1'
    helper.id_or_new_count(topic).should == '-new-2'
  end

end
