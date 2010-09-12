module CachingHelper
  ActionController::Base.public_class_method :page_cache_path
  ActionController::Base.perform_caching = true
  
  def requesting(&request)
    url = request.call.request.path
    ActionController::Base.expire_page(url)
    request.call
  end
  
  module ResponseHelper
    def cached?
      File.exists? ActionController::Base.page_cache_path(request.path)
    end
  end

  ActionController::TestResponse.send(:include, ResponseHelper)
end