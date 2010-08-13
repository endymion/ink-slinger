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
#

class Topic < ActiveRecord::Base
  has_many :panels, :dependent => :destroy, :order => 'updated_at DESC'
  accepts_nested_attributes_for :panels, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['image'].blank? }

  scope :image_topics, lambda {
    joins("INNER JOIN panels ON panels.topic_id = topics.id").
    select("topics.*, count(panels.id) panels_count").
    group("panels.topic_id HAVING panels_count > 0")
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