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
  attr_accessible :arrangement, :tile_256, :tile_512

  scope :for_topic, lambda {|topic|
    where("panels.topic_id = #{topic.id}")
  }
  scope :square, where("panels.arrangement = 'square'").order('updated_at DESC')
  scope :landscape, where("panels.arrangement = 'landscape'").order('updated_at DESC')
  scope :portrait, where("panels.arrangement = 'portrait'").order('updated_at DESC')

  path = "system/panels/:attachment/:id/:style.:extension"
  storage = :s3
  s3_credentials = "#{Rails.root}/config/s3.yml"
  bucket = "static.brave-new-media.com"
  has_attached_file :tile_256,
    :path => path,
    :storage => storage,
    :s3_credentials => s3_credentials,
    :bucket => bucket,
    :styles => lambda { |image|
      panel = image.instance
      {
        :original => {
          :geometry => "#{panel.width_for_tile_256}x#{panel.height_for_tile_256}#",
          :quality => 10,
          :format => 'jpg'
        }
      }
    }
  has_attached_file :tile_512,
    :path => path,
    :storage => storage,
    :s3_credentials => s3_credentials,
    :bucket => bucket,
    :styles => lambda { |image|
      panel = image.instance
      {
        :original => {
          :geometry => "#{panel.width_for_tile_512}x#{panel.height_for_tile_512}#",
          :quality => 10,
          :format => 'jpg'
        }
      }
    }

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

end
