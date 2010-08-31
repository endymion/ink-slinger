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

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
