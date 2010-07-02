require 'spec_helper'

describe Brand do

  describe "current configuration" do

    it "should return a list of brands" do
      Brand.configuration['brands'].count.should > 1
    end

    it "should return a host and asset server for each brand" do
      Brand.configuration['brands'].each { |brand| brand['host'].should_not == nil }
      Brand.configuration['brands'].each { |brand| brand['assets'].should_not == nil }
    end
  
    it "should return at least one location with a title and a subdomain for each brand" do
      Brand.configuration['brands'].each do |brand|
        (locations = brand['locations']).should_not == nil
        locations.count.should >= 1
      end
    end

  end

  describe "class" do

    before do
      Brand.configuration = YAML::load_file('spec/models/brands_test.yml')
    end

    it "should return a list of brands" do
      (brands = Brand.brands).count.should > 1
      brands.each do |brand|
        brand.host.should_not == nil
        brand.assets.should_not == nil
        brand.locations.should_not == nil
      end
    end

    it "should return a list of brands" do
      (brands = Brand.brands).count.should > 1
      brands.each { |brand| brand.host.should_not == nil }
    end

    it "should return a brand when given a host and a location given a subdomain" do
      (brand = Brand.get_brand('brave-new-media.com')).host.should == 'brave-new-media.com'
      brand.get_location('www').title.should == 'Brave New Media'
    end

  end

  describe "instance" do

    before do
      Brand.configuration = YAML::load_file('spec/models/brands_test.yml')
      @brand = Brand.new(Brand.configuration_brands.first)
    end
    
    it "should return its host" do
      @brand.host.should == 'brave-new-media.com'
    end

    it "should return its asset host" do
      @brand.assets.should == 'static.brave-new-media.com'
    end
    
    it "should return a list of locations that each includes a title and a subdomain" do
      (locations = @brand.locations).should_not == nil
      locations.each do |location|
        location.title.should_not == nil
        location.subdomain.should_not == nil
      end
      locations.first.title.should == 'Brave New Media'
      locations.first.subdomain.should == 'www'
    end

  end
  
end