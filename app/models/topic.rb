class Topic < ActiveRecord::Base
  has_many :panels, :dependent => :destroy, :order => 'updated_at DESC'
  accepts_nested_attributes_for :panels, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['image'].blank? }

  def square_panels
    Panel.for_topic(self).square
  end
end
