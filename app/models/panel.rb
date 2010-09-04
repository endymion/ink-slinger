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
  attr_accessible :topic, :image
  attr_accessible :tile_256, :tile_512
  attr_accessible :arrangement, :crop_x, :crop_y, :crop_w, :crop_h

  before_save :default_crop, :unless => :cropping?
  def default_crop
    file = panel_source_image.to_file(:original)
    source_width = Paperclip::Geometry.from_file(file).width
    source_height = Paperclip::Geometry.from_file(file).height
    source_aspect = source_width / source_height
    
    self.arrangement ||= 'square'
    
    aspect = case arrangement
    when 'landscape': 2
    when 'portrait': 0.5
    else
      1
    end
    
    if aspect < source_aspect
      self.crop_y = 0
      self.crop_h = 1
      crop_width = source_height * aspect
      self.crop_w = crop_width / source_width
      self.crop_x = (source_width/2 - crop_width/2) / source_width
    else
      self.crop_x = 0
      self.crop_w = 1
      crop_height = source_width / aspect
      self.crop_h = crop_height / source_height
      self.crop_y = (source_height/2 - crop_height/2) / source_height
    end
    
  end

  after_save :reprocess_tiles, :if => :cropping?
  def cropping?
    # If any are blank then not cropping.
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank? &&
    # Or if all are zero then not cropping.
    !(crop_x.zero? && crop_y.zero? && crop_w.zero? && crop_h.zero?)
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
      original = {
        :geometry => "#{panel.width_for_tile_256}x#{panel.height_for_tile_256}!",
        :quality => 10,
        :format => 'jpg'
      }
      if panel.panel_source_image.nil?
      else
        original = {
          :original_width => 
            Paperclip::Geometry.from_file(panel.panel_source_image.to_file(:original)).width,
          :original_height =>
            Paperclip::Geometry.from_file(panel.panel_source_image.to_file(:original)).height
        }.merge original
      end
      {
        :original => original
      }
    }
  }.merge(PAPERCLIP_CONFIG_PANELS)

  has_attached_file :tile_512, {
    :processors => [:cropper],
    :styles => lambda { |image|
      panel = image.instance
      original = {
        :geometry => "#{panel.width_for_tile_512}x#{panel.height_for_tile_512}!",
        :quality => 10,
        :format => 'jpg'
      }
      if panel.panel_source_image.nil?
      else
        original = {
          :original_width => 
            Paperclip::Geometry.from_file(panel.panel_source_image.to_file(:original)).width,
          :original_height =>
            Paperclip::Geometry.from_file(panel.panel_source_image.to_file(:original)).height
        }.merge original
      end
      {
        :original => original
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
  
  def panel_source_image
    return image.tile_512 if !image.nil? and !image.tile_512_file_name.nil?
    return image.tile_256 if !image.nil?
    nil
  end
  
  private

  def reprocess_tiles
    return if @reprocessed
    @reprocessed = true
    self.tile_512 = self.panel_source_image.to_file(:original)
    self.tile_256 = self.panel_source_image.to_file(:original)
    self.save
  end
  
end
