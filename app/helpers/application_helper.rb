module ApplicationHelper
  
  def brand_asset_url(url)
    brand_asset_host = (Thread.current[:brand].asset_host.gsub /\%d/, rand(4).to_s)
    if url.match /#{PAPERCLIP_CONFIG[:bucket]}(\/.*)$/
      return 'http://' + brand_asset_host + $1
    end
    url.gsub /\Ahttp\:\/\/[^\/]+\//,
      (brand_asset_host + '/')
  end
  
end
