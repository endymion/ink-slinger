# == Schema Information
#
# Table name: panels
#
#  id                    :integer         not null, primary key
#  arrangement           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  topic_id              :integer
#  t_1_file_name    :string(255)
#  t_1_content_type :string(255)
#  t_1_file_size    :integer
#  t_1_updated_at   :datetime
#  t_2_file_name    :string(255)
#  t_2_content_type :string(255)
#  t_2_file_size    :integer
#  t_2_updated_at   :datetime
#  image_id              :integer
#  crop_x                :float
#  crop_y                :float
#  crop_w                :float
#  crop_h                :float
#

class Panel < ActiveRecord::Base
  belongs_to :topic
  belongs_to :image
  attr_accessible :topic, :image, :image_id
  attr_accessible :t_1, :t_2
  attr_accessible :arrangement, :crop_x, :crop_y, :crop_w, :crop_h

  before_save :default_crop, :unless => :cropping?
  def default_crop
    file = image.panel_source_image.to_file(:original)
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

  has_attached_file :t_1, {
    :processors => [:cropper],
    :styles => lambda { |image|
      panel = image.instance
      original = {
        :geometry => "#{panel.width(256)}x#{panel.height(256)}!",
        :format => 'jpg'
      }
      if panel.image.nil? || panel.image.panel_source_image.nil?
      else
        original = {
          :original_width => 
            Paperclip::Geometry.from_file(panel.image.panel_source_image.to_file(:original)).width,
          :original_height =>
            Paperclip::Geometry.from_file(panel.image.panel_source_image.to_file(:original)).height
        }.merge original
      end
      {
        :original => original
      }
    },
    :convert_options => { :original => '-strip -quality 50' }
  }.merge(PAPERCLIP_CONFIG_PANELS)

  has_attached_file :t_2, {
    :processors => [:cropper],
    :styles => lambda { |image|
      panel = image.instance
      original = {
        :geometry => "#{panel.width(512)}x#{panel.height(512)}!",
        :format => 'jpg'
      }
      if panel.image.nil? || panel.image.panel_source_image.nil?
      else
        original = {
          :original_width => 
            Paperclip::Geometry.from_file(panel.image.panel_source_image.to_file(:original)).width,
          :original_height =>
            Paperclip::Geometry.from_file(panel.image.panel_source_image.to_file(:original)).height
        }.merge original
      end
      {
        :original => original
      }
    },
    :convert_options => { :original => '-strip -quality 50' }
  }.merge(PAPERCLIP_CONFIG_PANELS)

  before_post_process :topic_friendly_id_to_panel_file_names
  def topic_friendly_id
    if self.topic.nil?
      t_1_file_name.gsub(/\..*$/,'') unless t_1_file_name.blank?
    elsif (topic_id = self.topic.friendly_id).blank?
      self.topic.id
    else
      topic_id
    end
  end
  def topic_friendly_id_to_panel_file_names
    unless t_1_file_name.blank?
      extension = File.extname(t_1_file_name) 
      self.t_1.instance_write(:file_name, "#{topic_friendly_id}#{extension}") 
    end
    unless t_2_file_name.blank?
      extension = File.extname(t_2_file_name) 
      self.t_2.instance_write(:file_name, "#{topic_friendly_id}#{extension}") 
    end
  end
  
  def width(tile_width)
    if tile_width.eql? 512
      case arrangement
      when 'portrait'
        512
      when 'landscape'
        1024
      else 512
      end
    elsif tile_width.eql? 256
      width(512) / 2
    else
      raise "Invalid tile width for Panel: #{tile_width}"
    end
  end
  
  def height(tile_width)
    if tile_width.eql? 512
      case arrangement
      when 'portrait'
        1024
      when 'landscape'
        512
      else 512
      end
    elsif tile_width.eql? 256
      height(512) / 2
    else
      raise "Invalid tile height for Panel: #{tile_width}"
    end
  end
  
  def reprocess_tiles
    return if @reprocessed
    @reprocessed = true
    self.t_2 = image.panel_source_image.to_file(:original)
    self.t_1 = image.panel_source_image.to_file(:original)
    self.save
  end
  
end
