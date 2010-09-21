# == Schema Information
#
# Table name: brands
#
#  id                 :integer         not null, primary key
#  domain_name        :string(255)
#  asset_server       :string(255)
#  title              :string(255)
#  subdomain          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  application_domain :string(255)
#

require 'yaml'

class Brand < ActiveRecord::Base

  validates_uniqueness_of :subdomain, :scope => :domain_name

  @@configuration = YAML::load_file('config/brands.yml')
  
  # This method is the whole point of this entire class.
  def self.match(domain, subdomain)
    # Turn a .local into a .com, to help in local development.
    domain.gsub! /\.local/, '.com'
    # Trim the port off of any request.  It seems like subdomain_fu should do this?
    domain.gsub! /\:.+$/, ''
    # Trim off the subdomain if it ends up in the domain because of too many
    # domains in the full URL.  "the.miami.nightlifeobserver.com" becomes
    # "miami.nightlifeobserver.com".
    domain.gsub! /\A[^\.]+\./, '' if domain.match /.*\..*\..*/
    # Trim down to the right-most part of the subdomain.
    unless subdomain.nil?
      subdomain.gsub! /\A.+\./, '' if subdomain.match /.*\..*/
    end

    brand = Brand.where(:domain_name => domain, :subdomain => subdomain).first
    return brand unless brand.blank?
    
    # Use the default brand when there is no exact match.
    brand = Brand.where(:default => true).first
    raise "No default brand is set.  Please add default: true to one brand." if brand.nil?
    brand
  end

  def self.asset_hosts
    all.map { |brand|
      if brand.subdomain.eql? 'www'
        brand.asset_server
      else
        # Strip the "www." from the subdomain if it exists, because 'www.' has a
        # special meaning: it's the subdomain of the web application.
        subdomain = brand.subdomain.gsub /^www\./, ''

        # Rails asset servers are auto-numbered from 0 to 3.
        (0..3).to_a.map {|index| subdomain + "-#{index}." + brand.asset_server }.flatten
      end
    }.flatten
  end

  def self.application_hosts
    all.map { |brand|
      ((app = brand.application_domain).blank? ? '' : (app + '.')) +
      brand.subdomain + '.' + brand.domain_name
    }.flatten
  end

  def self.configuration
    @@configuration
  end
  def self.configuration=(new_configuration)
    @@configuration = new_configuration
  end
  
  def self.seed
    configuration_brands.each { |brand| brand.save }
  end

  # Instance methods.
  
  # If an application_domain is set then that means that caching is enabled.
  def application_host
    return [subdomain, domain_name].join('.') if application_domain.blank?
    [application_domain, subdomain, domain_name].join('.')
  end

  # If an application_domain is not set then that means that caching is disabled.
  def application_cache_host
    return nil if application_domain.blank?
    [subdomain, domain_name].join('.')
  end

  def asset_host
    if asset_server.match /\.[^\.]+\./ # Includes a subdomain.
      asset_server
    else
      "#{subdomain}-%d.#{asset_server}"
    end
  end

  def brand=(brand)
    self.domain_name = brand['domain_name']
    self.asset_server = brand['asset_server']
    self.title = brand['title']
    self.subdomain = brand['subdomain']
    self.application_domain = brand['application_domain']
    self.google_analytics_code = brand['google_analytics_code']
    self.default = brand['default']
  end

  def self.configuration_domains
    @@configuration['domain_names']
  end

  def self.configuration_brands
    @@configuration['domain_names'].map { |domain_yml|
      domain_yml['locations'].map { |location_yml|
        domain_yml['title'] = location_yml['title']
        domain_yml['subdomain'] = location_yml['subdomain']
        domain_yml['application_domain'] = location_yml['application_domain']
        domain_yml['google_analytics_code'] = location_yml['google_analytics_code']
        record = Brand.where(
          :title => location_yml['title'],
          :subdomain => location_yml['subdomain']).first || Brand.new
        record.brand = domain_yml
        record
      }
    }.flatten
  end

  # Used in path names for header images.
  def asset_name
    (subdomain + '.' + domain_name).gsub(/\W/, '_')
  end

end
