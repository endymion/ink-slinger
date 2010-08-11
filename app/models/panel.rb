class Panel < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :arrangement, :image

  scope :for_topic, lambda {|topic|
    where("panels.topic_id == #{topic.id}")
  }
  scope :square, where("panels.arrangement == 'square'")

  has_attached_file :image, 
    :path => "system/panels/:attachment/:id/:style.:extension",
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :bucket => "static.brave-new-media.com",
    :styles => lambda { |image|
        panel = image.instance
        {
          :tile_512 => {
            :geometry => "#{panel.width_for_tile_512}x#{panel.height_for_tile_512}#",
            :quality => 40,
            :format => 'JPG'
          },
          :tile_256 => {
            :geometry => "#{panel.width_for_tile_256}x#{panel.height_for_tile_256}#",
            :quality => 40,
            :format => 'JPG'
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