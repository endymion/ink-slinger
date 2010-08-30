class RenameImageAttachmentInPanelToFile < ActiveRecord::Migration
  def self.up
    rename_column :panels, :image_file_name, :tile_256_file_name
    rename_column :panels, :image_content_type, :tile_256_content_type
    rename_column :panels, :image_file_size, :tile_256_file_size
    rename_column :panels, :image_updated_at, :tile_256_updated_at
  end

  def self.down
    rename_column :panels, :tile_256_file_name, :image_file_name
    rename_column :panels, :tile_256_content_type, :image_content_type
    rename_column :panels, :tile_256_file_size, :image_file_size
    rename_column :panels, :tile_256_updated_at, :image_updated_at
  end
end
