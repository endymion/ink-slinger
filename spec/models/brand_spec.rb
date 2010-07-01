require 'spec_helper'

describe Brand do

  describe "configuration" do
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

  it "should return a list of brands" do
    (brands = Brand.brands).count.should > 1
    brands.each { |brand| brand['host'].should_not == nil }
  end
  
end