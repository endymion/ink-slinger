class AddPaperclipFieldsToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :tile_512_file_name, :string
    add_column :images, :tile_512_content_type, :string
    add_column :images, :tile_512_file_size, :integer
    add_column :images, :tile_512_updated_at, :datetime

    add_column :images, :tile_256_file_name, :string
    add_column :images, :tile_256_content_type, :string
    add_column :images, :tile_256_file_size, :integer
    add_column :images, :tile_256_updated_at, :datetime
  end

  def self.down
    remove_column :images, :tile_512_file_name
    remove_column :images, :tile_512_content_type
    remove_column :images, :tile_512_file_size
    remove_column :images, :tile_512_updated_at

    remove_column :images, :tile_256_file_name
    remove_column :images, :tile_256_content_type
    remove_column :images, :tile_256_file_size
    remove_column :images, :tile_256_updated_at
  end
end