# == Schema Information
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  panel      :string(255)
#  body       :text
#  published  :boolean
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#  venue_id   :integer
#

require 'spec_helper'

describe Topic do

  describe 'named scope' do

    before do
      rand(5).times { Topic.create } # Text topics.
      rand(5).times do
        topic = Topic.new
        topic.images << (image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg'))
        topic.panels << Panel.create(:image => image)
      end
    end

    _exceptions = [:ordered, :something_else_requiring_a_parameter, :scoped]
    (Topic.read_inheritable_attribute(:scopes).keys - _exceptions).each do |ns|
      it "#{ns.to_s} returns images" do
        Topic.send(ns).size.should_not be_nil
      end
    end
  end

  describe 'panel finding methods' do

    before do
      %w{square portrait landscape}.each do |panel_type|
        rand(5).times do
          @topic = Topic.create
          @topic.images << (image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg'))
          @topic.panels << Panel.create(:image => image, :arrangement => panel_type)
        end
      end
    end

    %w{square portrait landscape}.each do |panel_type|
      it "#{panel_type} returns panels" do
        @topic.send(panel_type + '_panels').should_not be_nil
      end
    end

  end

  describe 'file name SEO' do
    
    it 'should use the friendly_id for the topic as the file names for the image attachments.' do
      image = Factory.create :image, :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_1024.jpg')
      topic = Factory.create :topic, :title => 'A test topic', :images => [image]
      topic.images.first.should_not be_nil
      topic.images.first.t_1_file_name.should match /^a-test-topic.*\.jpg$/
      topic.images.first.t_2_file_name.should match /^a-test-topic.*\.jpg$/
    end
    
    it 'should use the friendly_id for the topic as the file names for the panel attachments' do
      image = Factory.create :image, :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg')
      panel = Panel.create :image => image, :arrangement => 'portrait'
      image.panels << panel
      image.save
      topic = Factory.create :topic, :title => 'A test topic', :images => [image]
      first_panel = topic.images.first.panels.first
      first_panel.should_not be_nil
      first_panel.arrangement.should == 'portrait'
      first_panel.t_1_file_name.should match /^a-test-topic.*\.jpg$/
      first_panel.t_1_file_name.should_not match /--\d/
    end

    it 'should update the names of the attachments when the friendly_id on the parent Topic changes' do
      image = Factory.create :image, :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg')
      panel = Panel.create :image => image, :arrangement => 'portrait'
      image.panels << panel
      image.save
      topic = Factory.create :topic, :title => 'A test topic', :images => [image]
      puts "done"
      topic.title = 'This is a different topic'
      topic.save
      first_panel = topic.images.first.panels.first
      first_panel.t_1_file_name.should match /^this-is-a-different-topic.*\.jpg$/
      first_panel.t_1_file_name.should_not match /--\d/
    end

  end

end
