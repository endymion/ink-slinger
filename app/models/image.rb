class Image < ActiveRecord::Base
  belongs_to :topic

  scope :for_topic, lambda {|topic|
    where("images.topic_id = #{topic.id}")
  }

  path = "system/images/:attachment/:id/:style.:extension"
  storage = :s3
  s3_credentials = "#{Rails.root}/config/s3.yml"
  bucket = "static.brave-new-media.com"
  has_attached_file :tile_256,
    :path => path,
    :storage => storage,
    :s3_credentials => s3_credentials,
    :bucket => bucket,
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
    :storage => storage,
    :s3_credentials => s3_credentials,
    :bucket => bucket,
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

end