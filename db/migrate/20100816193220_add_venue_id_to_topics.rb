class AddVenueIdToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :venue_id, :integer
  end

  def self.down
    remove_column :topics, :venue_id
  end
end
