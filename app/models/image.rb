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
    :convert_options => { :original => '-strip -quality 90' }
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
    :convert_options => { :original => '-strip -quality 90' }
  }.merge(PAPERCLIP_CONFIG_IMAGES)

  # alias :paperclip_tile_256= :tile_256=
  # def tile_256=(attachment)
  #   require 'ruby-debug'; debugger
  #   if Paperclip::Geometry.from_file(attachment).width.to_i > 512
  #     self.tile_512 = attachment
  #   end
  #   self.paperclip_tile_256 = attachment
  # end

  alias :paperclip_tile_256= :tile_256=
  def tile_256=(attachment)
    self.paperclip_tile_256 = attachment
    if Paperclip::Geometry.from_file(attachment).width.to_i > 512
      self.tile_512 = attachment
    end
  end

end