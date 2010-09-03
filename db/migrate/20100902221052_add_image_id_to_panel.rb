class AddImageIdToPanel < ActiveRecord::Migration
  def self.up
    add_column :panels, :image_id, :integer
  end

  def self.down
    remove_column :panels, :image_id
  end
end
