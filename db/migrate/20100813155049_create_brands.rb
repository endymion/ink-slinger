class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string  :domain_name
      t.string  :asset_server
      t.string  :title
      t.string  :subdomain

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
