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

class Image < ActiveRecord::Base
  belongs_to :topic
  has_many :panels

  scope :for_topic, lambda {|topic|
    where("images.topic_id = #{topic.id}")
  }

  # validates_attachment_size :tile_256, :less_than => 1.megabyte
  # validates_attachment_size :tile_512, :less_than => 1.megabyte

  has_attached_file :tile_256, {
    :processors => [:original], # Don't touch the file unless it's too large.
    :styles => lambda { |image|
      panel = image.instance
      {
        :original => {
          :geometry => "512>", # Two tiles wide.
          :max_width => 512,
          :format => 'jpg'
        }
      }
    },
    :convert_options => { :original => '-strip -quality 40' }
  }.merge(PAPERCLIP_CONFIG_IMAGES)
  
  has_attached_file :tile_512, {
    :processors => [:original], # Don't touch the file unless it's too large.
    :styles => lambda { |image|
      panel = image.instance
      {
        :original => {
          :geometry => "1024>", # Two tiles wide.
          :max_width => 1024,
          :format => 'jpg'
        }
      }
    },
    :convert_options => { :original => '-strip -quality 40' }
  }.merge(PAPERCLIP_CONFIG_IMAGES)

  before_post_process :topic_friendly_id_to_image_file_names
  def topic_friendly_id
    if self.topic.nil?
      tile_256_file_name.gsub(/\..*$/,'') unless tile_256_file_name.blank?
    elsif (topic_id = self.topic.friendly_id).blank?
      self.topic.id
    else
      topic_id
    end
  end
  def topic_friendly_id_to_image_file_names
    unless tile_256_file_name.blank?
      extension = File.extname(tile_256_file_name) 
      self.tile_256.instance_write(:file_name, "#{topic_friendly_id}#{extension}") 
    end
    unless tile_512_file_name.blank?
      extension = File.extname(tile_512_file_name) 
      self.tile_512.instance_write(:file_name, "#{topic_friendly_id}#{extension}") 
    end
  end
    
  alias :paperclip_tile_256= :tile_256=
  def tile_256=(attachment)
    self.paperclip_tile_256 = attachment
    if Paperclip::Geometry.from_file(attachment).width.to_i > 512
      self.tile_512 = attachment
    end
  end

  def panel_source_image
    return tile_512 if !tile_512_file_name.nil?
    return tile_256 if !tile_256_file_name.nil?
    nil
  end
  
end