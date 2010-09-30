class AddTile512ToPanel < ActiveRecord::Migration
  def self.up
    add_column :panels, :t_2_file_name, :string
    add_column :panels, :t_2_content_type, :string
    add_column :panels, :t_2_file_size, :integer
    add_column :panels, :t_2_updated_at, :datetime
  end

  def self.down
    remove_column :panels, :t_2_file_name
    remove_column :panels, :t_2_content_type
    remove_column :panels, :t_2_file_size
    remove_column :panels, :t_2_updated_at
  end
end
