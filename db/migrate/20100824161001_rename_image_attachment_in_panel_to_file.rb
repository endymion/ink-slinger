class RenameImageAttachmentInPanelToFile < ActiveRecord::Migration
  def self.up
    rename_column :panels, :image_file_name, :t_1_file_name
    rename_column :panels, :image_content_type, :t_1_content_type
    rename_column :panels, :image_file_size, :t_1_file_size
    rename_column :panels, :image_updated_at, :t_1_updated_at
  end

  def self.down
    rename_column :panels, :t_1_file_name, :image_file_name
    rename_column :panels, :t_1_content_type, :image_content_type
    rename_column :panels, :t_1_file_size, :image_file_size
    rename_column :panels, :t_1_updated_at, :image_updated_at
  end
end
