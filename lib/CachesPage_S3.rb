require 'fileutils'
require 'uri'
require 'active_support/core_ext/class/attribute_accessors'

module ActionController #:nodoc:
  module Caching
    module Pages
      
      def cache_page(content = nil, options = nil)
        return unless self.class.perform_caching && caching_allowed

        path = case options
          when Hash
            url_for(options.merge(:only_path => true, :format => params[:format]))
          when String
            options
          else
            request.path
        end

        self.class.cache_page(content || response.body, path)

        bucket = @current_brand.subdomain + '.' + @current_brand.domain_name
        name = page_cache_file(path)
        cache_path = File.join(page_cache_directory, name)
        
        Pages::copy_cached_page_to_s3(bucket, name, cache_path) unless
          @current_brand.application_domain.blank?
      end
      
      def self.copy_cached_page_to_s3(bucket, name, path)
        Rails.logger.info "Copying cached page to S3, to: #{File.join(bucket, name)}"

        @settings = YAML.load(ERB.new(File.new(
          File.join(Rails.root, 'config', 's3.yml')).read).result)

        AWS::S3::Base.establish_connection!(
          :access_key_id => @settings['access_key_id'],
          :secret_access_key => @settings['secret_access_key'])    

        AWS::S3::S3Object.store(
          name,
          open(path),
          bucket)        

        s3_object = AWS::S3::S3Object.find(name.gsub(/^\//,''), bucket)
        s3_object.cache_control = 'max-age=3600'
        s3_object.save({:access => :public_read})
      end

      def page_cache_file(path)
        name = (path.empty? || path == "/") ? "/index" : URI.unescape(path.chomp('/'))
        name << page_cache_extension unless (name.split('/').last || name).include? '.'
        return name
      end
            
    end
  end
end