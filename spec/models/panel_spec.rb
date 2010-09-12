# == Schema Information
#
# Table name: panels
#
#  id                    :integer         not null, primary key
#  arrangement           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  topic_id              :integer
#  tile_256_file_name    :string(255)
#  tile_256_content_type :string(255)
#  tile_256_file_size    :integer
#  tile_256_updated_at   :datetime
#  tile_512_file_name    :string(255)
#  tile_512_content_type :string(255)
#  tile_512_file_size    :integer
#  tile_512_updated_at   :datetime
#  image_id              :integer
#  crop_x                :float
#  crop_y                :float
#  crop_w                :float
#  crop_h                :float
#

require 'spec_helper'

describe Panel do

  describe "panel default cropping" do

    it "calculates a default crop on saving a new panel" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.new :image => image
      panel.should_receive(:default_crop)
      panel.save
    end

    it "does not calculate a default crop on saving an existing panel" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.new :image => image, :crop_x => 0, :crop_y => 0, :crop_w => 1, :crop_h => 1
      panel.should_not_receive(:default_crop)
      panel.save
    end

    it "is cropping when cropping values are set" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.new :image => image, :crop_x => 0, :crop_y => 0, :crop_w => 1, :crop_h => 1
      panel.cropping?.should == true
    end

    it "is not cropping when cropping values are not set" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.new :image => image
      panel.cropping?.should == false
    end

    it "is not cropping when cropping values are all zero" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.new :image => image, :crop_x => 0, :crop_y => 0, :crop_w => 0, :crop_h => 0
      panel.cropping?.should == false
    end

    it "reprocesses tiles after saving a topic with cropping values" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.new :image => image, :crop_x => 0, :crop_y => 0, :crop_w => 1, :crop_h => 1
      panel.should_receive(:reprocess_tiles)
      panel.save
    end

  end
  
  describe "with square source image" do
  
    it "should crop a square from a square" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.create :image => image
      panel.crop_x.should == 0
      panel.crop_y.should == 0
      panel.crop_w.should == 1
      panel.crop_h.should == 1
    end
    
    it "should crop a landscape from a square" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.create :image => image, :arrangement => 'landscape'
      panel.crop_x.should == 0
      panel.crop_y.should == 0.25
      panel.crop_w.should == 1
      panel.crop_h.should == 0.5
    end
  
    it "should crop a portrait from a square" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
      panel = Panel.create :image => image, :arrangement => 'portrait'
      panel.crop_x.should == 0.25
      panel.crop_y.should == 0
      panel.crop_w.should == 0.5
      panel.crop_h.should == 1
    end
        
  end

  describe "with a landscape source image" do

    it "should crop a square from a landscape" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x50.jpg')
      panel = Panel.create :image => image
      panel.crop_x.should == 0.25
      panel.crop_y.should == 0
      panel.crop_w.should == 0.5
      panel.crop_h.should == 1
    end
    
    it "should crop a landscape from a landscape" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x50.jpg')
      panel = Panel.create :image => image, :arrangement => 'landscape'
      panel.crop_x.should == 0
      panel.crop_y.should == 0
      panel.crop_w.should == 1
      panel.crop_h.should == 1
    end

    it "should crop a portrait from a landscape" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x50.jpg')
      panel = Panel.create :image => image, :arrangement => 'portrait'
      panel.crop_x.should == 0.375
      panel.crop_y.should == 0
      panel.crop_w.should == 0.25
      panel.crop_h.should == 1
    end

  end

  describe "with a portrait source image" do

    it "should crop a square from a portrait" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x200.jpg')
      panel = Panel.create :image => image
      panel.crop_x.should == 0
      panel.crop_y.should == 0.25
      panel.crop_w.should == 1
      panel.crop_h.should == 0.5
    end

    it "should crop a landscape from a portrait" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x200.jpg')
      panel = Panel.create :image => image, :arrangement => 'landscape'
      panel.crop_x.should == 0
      panel.crop_y.should == 0.375
      panel.crop_w.should == 1
      panel.crop_h.should == 0.25
    end

    it "should crop a portrait from a portrait" do
      image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x200.jpg')
      panel = Panel.create :image => image, :arrangement => 'portrait'
      panel.crop_x.should == 0
      panel.crop_y.should == 0
      panel.crop_w.should == 1
      panel.crop_h.should == 1
    end

  end

  describe 'height and width' do
    
    describe 'for square images' do
      before do
        image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x200.jpg')
        @panel = Panel.create :image => image, :arrangement => 'square'
      end
      describe 'for the 256px wide tile' do
        it 'width should be 256px' do
          @panel.width(256).should == 256
        end
        it 'height should be 256px' do
          @panel.height(256).should == 256
        end
      end
      describe 'for the 512px wide tile' do
        it 'width should be 512px' do
          @panel.width(512).should == 512
        end
        it 'height should be 512px' do
          @panel.height(512).should == 512
        end
      end
    end

    describe 'for landscape images' do
      before do
        image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x200.jpg')
        @panel = Panel.create :image => image, :arrangement => 'landscape'
      end
      describe 'for the 256px wide tile' do
        it 'width should be 512px' do
          @panel.width(256).should == 512
        end
        it 'height should be 256px' do
          @panel.height(256).should == 256
        end
      end
      describe 'for the 512px wide tile' do
        it 'width should be 1024px' do
          @panel.width(512).should == 1024
        end
        it 'height should be 512px' do
          @panel.height(512).should == 512
        end
      end
    end

    describe 'for portrait images' do
      before do
        image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x200.jpg')
        @panel = Panel.create :image => image, :arrangement => 'portrait'
      end
      describe 'for the 256px wide tile' do
        it 'width should be 512px' do
          @panel.width(256).should == 256
        end
        it 'height should be 256px' do
          @panel.height(256).should == 512
        end
      end
      describe 'for the 512px wide tile' do
        it 'width should be 512px' do
          @panel.width(512).should == 512
        end
        it 'height should be 1024px' do
          @panel.height(512).should == 1024
        end
      end
    end

    describe 'for invalid tile sizes' do
      before do
        image = Image.create :tile_256 => File.new(Rails.root + 'spec/fixtures/images/test_100x100.jpg')
        @panel = Panel.create :image => image, :arrangement => 'portrait'
      end
      it 'height should raise an exception' do
        expect {
          puts @panel.height(257)
        }.to raise_error(
          "Invalid tile height for Panel: 257"
        )
      end
      it 'width should raise an exception' do
        expect {
          puts @panel.width(257)
        }.to raise_error(
          "Invalid tile width for Panel: 257"
        )
      end
    end

  end

end
