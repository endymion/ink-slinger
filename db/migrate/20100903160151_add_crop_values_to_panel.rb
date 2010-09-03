class AddCropValuesToPanel < ActiveRecord::Migration
  def self.up
    add_column :panels, :crop_x, :float
    add_column :panels, :crop_y, :float
    add_column :panels, :crop_w, :float
    add_column :panels, :crop_h, :float
  end

  def self.down
    remove_column :panels, :crop_h
    remove_column :panels, :crop_w
    remove_column :panels, :crop_y
    remove_column :panels, :crop_x
  end
end
