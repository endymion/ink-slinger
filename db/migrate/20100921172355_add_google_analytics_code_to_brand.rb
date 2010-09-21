class AddGoogleAnalyticsCodeToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :google_analytics_code, :string
  end

  def self.down
    remove_column :brands, :google_analytics_code
  end
end
