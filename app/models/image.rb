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

  path = "system/images/:attachment/:id/:style.:extension"
  has_attached_file :tile_256,
    :path => path,
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
    
  has_attached_file :tile_512,
    :path => path,
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
    }  ,
    :convert_options => { :original => '-strip -quality 90' }

  alias :paperclip_tile_512= :tile_512=
  def tile_512=(attachment)
    self.paperclip_tile_512 = attachment
    self.tile_256 = attachment
  end

  after_save :prune_duplicates
  def prune_duplicates
    return if tile_512_file_name.nil?
    # Discard the tile_512 image if it's not any larger than the tile_256 image.
    if Paperclip::Geometry.from_file(tile_512.to_file(:original)).width.to_i <= 512
      self.paperclip_tile_512 = nil
      self.save
    end
  end

end
