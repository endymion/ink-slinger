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
#

class Panel < ActiveRecord::Base
  belongs_to :topic
  belongs_to :image
  attr_accessible :arrangement, :tile_256, :tile_512

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h
  after_create :reprocess_tiles, :if => :cropping?
  after_update :reprocess_tiles, :if => :cropping?
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?  
  end  
  
  scope :for_topic, lambda {|topic|
    where("panels.topic_id = #{topic.id}")
  }
  scope :square, where("panels.arrangement = 'square'").order('updated_at DESC')
  scope :landscape, where("panels.arrangement = 'landscape'").order('updated_at DESC')
  scope :portrait, where("panels.arrangement = 'portrait'").order('updated_at DESC')

  has_attached_file :tile_256, {
    :processors => [:cropper],
    :styles => lambda { |image|
      panel = image.instance
      {
        :original => {
          :geometry => "#{panel.width_for_tile_256}x#{panel.height_for_tile_256}#",
          :quality => 10,
          :format => 'jpg',
          :original_width => 
            Paperclip::Geometry.from_file(panel.topic.images.first.tile_512.to_file(:original)).width,
          :original_height =>
            Paperclip::Geometry.from_file(panel.topic.images.first.tile_512.to_file(:original)).height
        }
      }
    }
  }.merge(PAPERCLIP_CONFIG_PANELS)

  has_attached_file :tile_512, {
    :processors => [:cropper],
    :styles => lambda { |image|
      panel = image.instance
      {
        :original => {
          :geometry => "#{panel.width_for_tile_512}x#{panel.height_for_tile_512}#",
          :quality => 10,
          :format => 'jpg',
          :original_width => 
            Paperclip::Geometry.from_file(panel.topic.images.first.tile_512.to_file(:original)).width,
          :original_height =>
            Paperclip::Geometry.from_file(panel.topic.images.first.tile_512.to_file(:original)).height
        }
      }
    }
  }.merge(PAPERCLIP_CONFIG_PANELS)

  def width_for_tile_512
    case arrangement
    when 'portrait'
      512
    when 'landscape'
      1024
    else 512
    end
  end
  def height_for_tile_512
    case arrangement
    when 'portrait'
      1024
    when 'landscape'
      512
    else 512
    end
  end
  
  def width_for_tile_256
    width_for_tile_512 / 2
  end
  def height_for_tile_256
    height_for_tile_512 / 2
  end
  
  private

  def reprocess_tiles
    return if @reprocessed
    @reprocessed = true
    self.tile_512 = self.topic.images.first.tile_512.to_file(:original)
    self.tile_256 = self.topic.images.first.tile_512.to_file(:original)
    self.save
  end
  
end
