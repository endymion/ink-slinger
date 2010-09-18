module ApplicationHelper
  
  def brand_asset_url(url)
    url.gsub /\Ahttp\:\/\/[^\/]+\//,
      ((Thread.current[:brand].asset_host.gsub /\%d/, rand(4).to_s) + '/')
  end
  
end
