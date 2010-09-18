require 'spec_helper'

describe ApplicationHelper do

  PAPERCLIP_CONFIG = { :bucket => "static.brave-new-media.com" }
  
  it "brand_asset_url(url) generates an asset server URL for the current brand" do
    Thread.current[:brand] = Brand.where(
      :subdomain => 'miami', :domain_name => 'something-chronicle.com').first
    url = helper.brand_asset_url('http://something.com/something')
    url.should match /miami\-\d\.some\-keyword\-events\.com\/something/
  end

  it "brand_asset_url(url) generates an asset server URL from an S3 URL" do
    Thread.current[:brand] = Brand.where(
      :subdomain => 'miami', :domain_name => 'something-chronicle.com').first
    url = helper.brand_asset_url('http://s3.amazonaws.com/static.brave-new-media.com/system/panels/tile_256s/1/original.jpg?1284771276')
    url.should match /miami\-\d\.some\-keyword\-events\.com\/system\/panels/
  end
  
end