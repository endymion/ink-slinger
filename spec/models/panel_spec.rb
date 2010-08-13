# == Schema Information
#
# Table name: panels
#
#  id                 :integer         not null, primary key
#  arrangement        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  topic_id           :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require 'spec_helper'

describe Panel do
  pending "add some examples to (or delete) #{__FILE__}"
end