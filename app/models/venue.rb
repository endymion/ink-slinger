class Venue < Topic
  has_many :events
  acts_as_taggable_on :locations
end
