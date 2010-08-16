class Venue < Topic
  acts_as_taggable_on :locations
end
