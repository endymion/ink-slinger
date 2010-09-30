# == Schema Information
#
# Table name: images
#
#  id                    :integer         not null, primary key
#  topic_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#  t_2_file_name    :string(255)
#  t_2_content_type :string(255)
#  t_2_file_size    :integer
#  t_2_updated_at   :datetime
#  t_1_file_name    :string(255)
#  t_1_content_type :string(255)
#  t_1_file_size    :integer
#  t_1_updated_at   :datetime
#

require 'spec_helper'

describe Image do

  describe "image file uploads" do
    
    it "should accept an image attachment" do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg')
      image.t_1_file_name.should_not be_nil
    end

    it "should end up with only an unresized t_1 image if the image is smaller than 512 wide" do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg')
      image.t_1_file_name.should_not be_nil
      image.t_2_file_name.should be_nil
      Paperclip::Geometry.from_file(image.t_1.to_file(:original)).width.to_i.should eql(256)
    end

    it "should end up with only a t_1 image if the image is exacly 512 wide" do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_512.jpg')
      image.t_1_file_name.should_not be_nil
      image.t_2_file_name.should be_nil
      Paperclip::Geometry.from_file(image.t_1.to_file(:original)).width.to_i.should eql(512)
    end

    it "should end up with both images if the image is over 512 wide" do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_768.jpg')
      image.t_1_file_name.should_not be_nil
      image.t_2_file_name.should_not be_nil
      Paperclip::Geometry.from_file(image.t_1.to_file(:original)).width.to_i.should eql(512)
      Paperclip::Geometry.from_file(image.t_2.to_file(:original)).width.to_i.should eql(768)
    end

    it "should end up with both images if the image is 1024 wide" do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_1024.jpg')
      image.t_1_file_name.should_not be_nil
      image.t_2_file_name.should_not be_nil
      Paperclip::Geometry.from_file(image.t_1.to_file(:original)).width.to_i.should eql(512)
      Paperclip::Geometry.from_file(image.t_2.to_file(:original)).width.to_i.should eql(1024)
    end

    it "should end up with both images if the image is over 1024 wide" do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_1280.jpg')
      image.t_1_file_name.should_not be_nil
      image.t_2_file_name.should_not be_nil
      Paperclip::Geometry.from_file(image.t_1.to_file(:original)).width.to_i.should eql(512)
      Paperclip::Geometry.from_file(image.t_2.to_file(:original)).width.to_i.should eql(1024)
    end
    
  end

  describe 'panel source image' do
    
    it 'should be the image for 512px-wide tiles if one exists' do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_1024.jpg')
      Paperclip::Geometry.from_file(image.panel_source_image.to_file(:original)).width.to_i.should eql(1024)
    end

    it 'should be the image for 256px-wide tiles if no image exists for 512px-wide tiles' do
      image = Image.create :t_1 => File.new(Rails.root + 'spec/fixtures/images/test_512.jpg')
      Paperclip::Geometry.from_file(image.panel_source_image.to_file(:original)).width.to_i.should eql(512)
    end

    it 'should be nil if there are no images attached' do
      image = Image.create
      image.panel_source_image.should eql(nil)
    end
    
  end
  
  it 'should find images for a given topic' do
    image1 = Factory.create(:image)
    image2 = Factory.create(:image)
    topic = Factory.create(:topic, :images => [image1, image2])
    Image.for_topic(topic).size.should == 2
  end
  
end
