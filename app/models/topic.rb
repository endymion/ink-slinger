class Topic < ActiveRecord::Base
  has_many :panels, :dependent => :destroy
  accepts_nested_attributes_for :panels, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['image'].blank? }
end
