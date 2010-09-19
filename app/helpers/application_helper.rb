module ApplicationHelper
  
  def brand_asset_url(url)
    return url if Rails.env.eql? 'development'
    brand_asset_host = (Thread.current[:brand].asset_host.gsub /\%d/, rand(4).to_s)
    if url.match /#{PAPERCLIP_CONFIG[:bucket]}(\/.*)$/
      return 'http://' + brand_asset_host + $1
    end
    url.gsub /\Ahttp\:\/\/[^\/]+\//,
      (brand_asset_host + '/')
  end

  def brand_application_host
    return '' unless Rails.env.eql? 'production'
    "http://#{@current_brand.application_host}"
  end
  
end
