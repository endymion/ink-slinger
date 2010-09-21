class AddDefaultToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :default, :boolean
  end

  def self.down
    remove_column :brands, :default
  end
end
