class AddApplicationDomainToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :application_domain, :string
  end

  def self.down
    remove_column :brands, :application_domain
  end
end
