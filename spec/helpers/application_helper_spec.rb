require 'spec_helper'

describe ApplicationHelper do
  
  it "brand_asset_url(url) generates an asset server URL for the current brand" do
    Thread.current[:brand] = Brand.where(
      :subdomain => 'miami', :domain_name => 'something-chronicle.com').first
    url = helper.brand_asset_url('http://something.com/something')
    url.should match /miami\-\d\.some\-keyword\-events\.com\/something/
  end
  
end