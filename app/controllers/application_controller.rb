class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  before_filter :get_current_brand
  def get_current_brand
    @current_brand = Brand.get_brand(current_domain)
    @current_brand_location = @current_brand.get_location(current_subdomain)
  end

end
