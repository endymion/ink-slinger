class AddPaperclipFieldsToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :t_2_file_name, :string
    add_column :images, :t_2_content_type, :string
    add_column :images, :t_2_file_size, :integer
    add_column :images, :t_2_updated_at, :datetime

    add_column :images, :t_1_file_name, :string
    add_column :images, :t_1_content_type, :string
    add_column :images, :t_1_file_size, :integer
    add_column :images, :t_1_updated_at, :datetime
  end

  def self.down
    remove_column :images, :t_2_file_name
    remove_column :images, :t_2_content_type
    remove_column :images, :t_2_file_size
    remove_column :images, :t_2_updated_at

    remove_column :images, :t_1_file_name
    remove_column :images, :t_1_content_type
    remove_column :images, :t_1_file_size
    remove_column :images, :t_1_updated_at
  end
end