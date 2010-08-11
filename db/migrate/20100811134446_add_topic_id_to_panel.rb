class AddTopicIdToPanel < ActiveRecord::Migration
  def self.up
    add_column :panels, :topic_id, :integer
  end

  def self.down
    remove_column :panels, :topic_id
  end
end
