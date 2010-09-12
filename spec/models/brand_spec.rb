# == Schema Information
#
# Table name: brands
#
#  id                 :integer         not null, primary key
#  domain_name        :string(255)
#  asset_server       :string(255)
#  title              :string(255)
#  subdomain          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  application_domain :string(255)
#

require 'spec_helper'

describe Brand do

  describe "current configuration" do

    it "should return a list of brands" do
      Brand.configuration['domain_names'].count.should > 1
    end

    it "should return a list of configuration domains" do
      Brand.configuration_domains.count.should > 1
    end

    it "should return a list of asset hosts" do
      (hosts = Brand.asset_hosts).count.should > 1
      for host in hosts do
        host.should match /\.\w+$/ # Feeble URL validation!
        host.should_not match '^www\.'
      end
    end

    it "should return a list of application hosts" do
      (hosts = Brand.application_hosts).count.should > 1
      for host in hosts do
        host.should match /\.\w+$/
      end      
    end

    it "should return a host and asset server for each brand" do
      Brand.configuration['domain_names'].each { |brand| brand['domain_name'].should_not == nil }
      Brand.configuration['domain_names'].each { |brand| brand['asset_server'].should_not == nil }
    end

  end

  describe "class" do

    before do
      Brand.all.each { |brand| brand.destroy }
      Brand.configuration = YAML::load_file('spec/models/brands_test.yml')
      Brand.seed
    end

    it "should return a list of brands" do
      (brands = Brand.all).count.should > 1
      brands.each do |brand|
        brand.domain_name.should_not == nil
        brand.asset_server.should_not == nil
      end
    end

    it "should return a list of brands" do
      (brands = Brand.all).count.should > 1
      brands.each { |brand| brand.domain_name.should_not == nil }
    end

    it "should return a brand when given a host and a subdomain" do
      (brand = Brand.match('brave-new-media.com', 'www')).domain_name.should == 'brave-new-media.com'
      brand.title.should == 'Brave New Media'
    end

  end

  describe "instance" do

    before do
      Brand.all.each { |brand| brand.destroy }
      Brand.configuration = YAML::load_file('spec/models/brands_test.yml')
      Brand.seed
      @brand = Brand.find(:first, :conditions => {
        :subdomain => 'miami',
        :domain_name => 'nightlifeobserver.com'
      })
    end
    
    it "should return its host" do
      @brand.domain_name.should == 'nightlifeobserver.com'
    end

    it "should return its asset host" do
      @brand.asset_server.should == 'night-club-events.com'
    end

    it "should return an asset name" do
      @brand.asset_name.should == 'miami_nightlifeobserver_com'
    end
    
    it "should return a title" do
      @brand.title.should == 'The Miami Nightlife Observer'
    end
    
    it "should return a subdomain" do
      @brand.subdomain.should == 'miami'
    end

    it "should return an application name" do
      @brand.application_domain.should == 'www'
    end

  end
  
end
