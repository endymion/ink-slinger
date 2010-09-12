class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  before_filter :get_current_brand
  def get_current_brand
    @current_brand = Brand.match(current_domain, current_subdomain)
    logger.info "Brand is: #{@current_brand.title}"
  end

end
