# == Schema Information
#
# Table name: images
#
#  id                    :integer         not null, primary key
#  topic_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#  tile_512_file_name    :string(255)
#  tile_512_content_type :string(255)
#  tile_512_file_size    :integer
#  tile_512_updated_at   :datetime
#  tile_256_file_name    :string(255)
#  tile_256_content_type :string(255)
#  tile_256_file_size    :integer
#  tile_256_updated_at   :datetime
#

require 'spec_helper'

describe Image do

  describe "file uploads" do
    
    it "should accept an image attachment" do
      image = Image.create :tile_512 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg')
      image.tile_256_file_name.should_not be_nil
    end

    it "should end up with only an unresized tile_256 image if the image is smaller than 512 wide" do
      image = Image.create :tile_512 => File.new(Rails.root + 'spec/fixtures/images/test_256.jpg')
      image.tile_256_file_name.should_not be_nil
      image.tile_512_file_name.should be_nil
      Paperclip::Geometry.from_file(image.tile_256.to_file(:original)).width.to_i.should eql(256)
    end

    it "should end up with only a tile_256 image if the image is exacly 512 wide" do
      image = Image.create :tile_512 => File.new(Rails.root + 'spec/fixtures/images/test_512.jpg')
      image.tile_256_file_name.should_not be_nil
      image.tile_512_file_name.should be_nil
      Paperclip::Geometry.from_file(image.tile_256.to_file(:original)).width.to_i.should eql(512)
    end

    it "should end up with both images if the image is over 512 wide" do
      image = Image.create :tile_512 => File.new(Rails.root + 'spec/fixtures/images/test_768.jpg')
      image.tile_256_file_name.should_not be_nil
      image.tile_512_file_name.should_not be_nil
      Paperclip::Geometry.from_file(image.tile_256.to_file(:original)).width.to_i.should eql(512)
      Paperclip::Geometry.from_file(image.tile_512.to_file(:original)).width.to_i.should eql(768)
    end

    it "should end up with both images if the image is 1024 wide" do
      image = Image.create :tile_512 => File.new(Rails.root + 'spec/fixtures/images/test_1024.jpg')
      image.tile_256_file_name.should_not be_nil
      image.tile_512_file_name.should_not be_nil
      Paperclip::Geometry.from_file(image.tile_256.to_file(:original)).width.to_i.should eql(512)
      Paperclip::Geometry.from_file(image.tile_512.to_file(:original)).width.to_i.should eql(1024)
    end

    it "should end up with both images if the image is over 1024 wide" do
      image = Image.create :tile_512 => File.new(Rails.root + 'spec/fixtures/images/test_1280.jpg')
      image.tile_256_file_name.should_not be_nil
      image.tile_512_file_name.should_not be_nil
      Paperclip::Geometry.from_file(image.tile_256.to_file(:original)).width.to_i.should eql(512)
      Paperclip::Geometry.from_file(image.tile_512.to_file(:original)).width.to_i.should eql(1024)
    end
    
  end

end
