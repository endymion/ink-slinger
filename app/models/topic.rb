# == Schema Information
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  panel      :string(255)
#  body       :text
#  published  :boolean
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#  venue_id   :integer
#

class Topic < ActiveRecord::Base
  has_friendly_id :seo_text, :use_slug => true, :allow_nil => true
  def seo_text 
    title
  end
  
  has_many :images, :dependent => :destroy, :order => 'updated_at DESC'
  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['t_1'].blank? }

  has_many :panels, :dependent => :destroy, :order => 'updated_at DESC'
  accepts_nested_attributes_for :panels, :allow_destroy => true

  # A simple hack to friendly_id to keep it from creating duplicate slugs during before_save.
  attr_accessor :no_slug

  after_create :update_attachment_file_names
  after_update :update_attachment_file_names

  def update_attachment_file_names
    do_update = images.inject(false) do |do_it, image|
      do_it = true unless image.t_1_file_name =~ /#{friendly_id}/
    end
    
    do_update_attachment_file_names if do_update
  end
  
  def do_update_attachment_file_names
    new_images = []
    old_images = images.clone
    for image in old_images do
      new_image = Image.new
      new_image.topic = self
      self.no_slug = true
      new_image.save
      self.no_slug = false
      unless image.t_2.to_file.nil?
        new_image.t_1 = image.t_2.to_file
      else
        unless image.t_1.to_file.nil?
          new_image.t_1 = image.t_1.to_file
        else
          next
        end
      end
     new_image.save # Redundant because of the one under the panels loop.
    
      new_image_panels = []
      old_image_panels = image.panels.clone
      for panel in image.panels do
        new_panel = Panel.new(panel.attributes.reject{|attribute, value| attribute.first.match /tile_/})
        new_panel.topic = self
        new_panel.save
        new_panel.reprocess_tiles
        new_image_panels << new_panel
        new_panel.save
      end
    
      old_image_panels.each do |panel|
        image.panels.delete(panel)
        panel.destroy
      end
      new_image.panels = new_image_panels
      new_image.save
      
      new_images << new_image
      
    end
    self.images << new_images
    old_images.each do |image|
      self.images.delete(image)
      image.destroy
    end
    true
  end

  acts_as_taggable_on :tags

  scope :image_topics, lambda {
    where('topics.id IN ' +
    '(SELECT topics.id FROM topics LEFT JOIN panels ON panels.topic_id = topics.id ' +
    'WHERE panels.topic_id IS NOT NULL)')
  }
  scope :text_topics, lambda {
    where('topics.id IN ' +
    '(SELECT topics.id FROM topics LEFT JOIN panels ON panels.topic_id = topics.id ' +
    'WHERE panels.topic_id IS NULL)')
  }

  def square_panels
    Panel.for_topic(self).square
  end
  def landscape_panels
    Panel.for_topic(self).landscape
  end
  def portrait_panels
    Panel.for_topic(self).portrait
  end

end
