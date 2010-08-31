# == Schema Information
#
# Table name: panels
#
#  id                    :integer         not null, primary key
#  arrangement           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  topic_id              :integer
#  tile_256_file_name    :string(255)
#  tile_256_content_type :string(255)
#  tile_256_file_size    :integer
#  tile_256_updated_at   :datetime
#  tile_512_file_name    :string(255)
#  tile_512_content_type :string(255)
#  tile_512_file_size    :integer
#  tile_512_updated_at   :datetime
#

require 'spec_helper'

describe Panel do
  pending "add some examples to (or delete) #{__FILE__}"
end
