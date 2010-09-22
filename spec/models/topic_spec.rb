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
        topic.images << (image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg'))
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
          @topic.images << (image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg'))
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

end
