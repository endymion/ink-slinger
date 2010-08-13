# == Schema Information
#
# Table name: brands
#
#  id           :integer         not null, primary key
#  domain_name  :string(255)
#  asset_server :string(255)
#  title        :string(255)
#  subdomain    :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Brand do

  describe "current configuration" do

    it "should return a list of brands" do
      Brand.configuration['domain_names'].count.should > 1
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
      @brand = Brand.first
    end
    
    it "should return its host" do
      @brand.domain_name.should == 'brave-new-media.com'
    end

    it "should return its asset host" do
      @brand.asset_server.should == 'static.brave-new-media.com'
    end
    
    it "should return a title" do
      @brand.title.should == 'Brave New Media'
    end
    
    it "should return a subdomain" do
      @brand.subdomain.should == 'www'
    end

  end
  
end