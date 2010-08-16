class AddTypeToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :type, :string
  end

  def self.down
    remove_column :topics, :type
  end
end
