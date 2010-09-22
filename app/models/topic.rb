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
  has_friendly_id :title, :use_slug => true, :allow_nil => true
  
  has_many :images, :dependent => :destroy, :order => 'updated_at DESC'
  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['tile_256'].blank? }

  has_many :panels, :dependent => :destroy, :order => 'updated_at DESC'
  accepts_nested_attributes_for :panels, :allow_destroy => true

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
