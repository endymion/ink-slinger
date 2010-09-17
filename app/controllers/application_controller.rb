class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  before_filter :get_current_brand
  def get_current_brand
    @current_brand = Brand.match(current_domain, current_subdomain)
    Thread.current[:brand] = @current_brand # Pass to the proc that sets asset_host.
    logger.info "Brand is: #{@current_brand.title}"
  end

end
