class RemovePublishedAndAddStatusToTopics < ActiveRecord::Migration
  def self.up
    remove_column :topics, :published
    add_column :topics, :status, :string
  end

  def self.down
    add_column :topics, :published, :boolean
    remove_column :topics, :status
  end
end
