# == Schema Information
#
# Table name: images
#
#  id                    :integer         not null, primary key
#  topic_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#  t_2_file_name    :string(255)
#  t_2_content_type :string(255)
#  t_2_file_size    :integer
#  t_2_updated_at   :datetime
#  t_1_file_name    :string(255)
#  t_1_content_type :string(255)
#  t_1_file_size    :integer
#  t_1_updated_at   :datetime
#

class Image < ActiveRecord::Base
  belongs_to :topic
  has_many :panels

  scope :for_topic, lambda {|topic|
    where("images.topic_id = #{topic.id}")
  }

  # validates_attachment_size :t_1, :less_than => 1.megabyte
  # validates_attachment_size :t_2, :less_than => 1.megabyte

  has_attached_file :t_1, {
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
  
  has_attached_file :t_2, {
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
      t_1_file_name.gsub(/\..*$/,'') unless t_1_file_name.blank?
    elsif (topic_id = self.topic.friendly_id).blank?
      self.topic.id
    else
      topic_id
    end
  end
  def topic_friendly_id_to_image_file_names
    unless t_1_file_name.blank?
      extension = File.extname(t_1_file_name) 
      self.t_1.instance_write(:file_name, "#{topic_friendly_id}#{extension}") 
    end
    unless t_2_file_name.blank?
      extension = File.extname(t_2_file_name) 
      self.t_2.instance_write(:file_name, "#{topic_friendly_id}#{extension}") 
    end
  end
    
  alias :paperclip_t_1= :t_1=
  def t_1=(attachment)
    self.paperclip_t_1 = attachment
    if Paperclip::Geometry.from_file(attachment).width.to_i > 512
      self.t_2 = attachment
    end
  end

  def panel_source_image
    return t_2 if !t_2_file_name.nil?
    return t_1 if !t_1_file_name.nil?
    nil
  end
  
end