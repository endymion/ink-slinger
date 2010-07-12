require 'yaml'

class Brand

  @@configuration = YAML::load_file('config/brands.yml')

  # Class methods.
  
  def self.configuration
    @@configuration
  end
  def self.configuration=(new_configuration)
    @@configuration
  end
  
  def self.configuration_brands
    @@configuration['brands']
  end
  
  def self.brands
    @@configuration['brands'].map { |brand| Brand.new(brand) }
  end

  def self.asset_hosts
    brands.map { |brand|
      brand.locations.map {|location|
        unless location.subdomain.eql? 'www'
          (0..3).to_a.map {|index| location.subdomain + "-#{index}." + brand.assets }.flatten
        else
          brand.assets
        end
      }
    }.flatten
  end

  def self.application_hosts
    # The base brand domain name.
    hosts = brands.map {|brand| brand.host}

    # Add all brand subdomains.
    hosts += brands.map { |brand|
      brand.locations.map {|location| location.subdomain + '.' + brand.host}
    }.flatten
  end

  # This method is the whole point of this entire class.
  def self.get_brand(domain)
    # Turn a .local into a .com, to help in local development.
    domain.gsub! /\.local/, '.com'
    # Trim the port off of any request.  It seems like subdomain_fu should do this?
    domain.gsub! /\:.+$/, ''

    brands.each { |brand| return brand if brand.host.eql? domain }
    brands.first
  end

  # Instance methods.

  def initialize(brand)
    @brand = brand
  end

  def host
    @brand['host']
  end

  def assets
    @brand['assets']
  end

  def locations
    @brand['locations'].map { |location| BrandLocation.new(location) }
  end

  def get_location(subdomain)
    locations.each { |location| return location if location.subdomain.eql? subdomain }
    locations.first
  end

end

class BrandLocation

  def initialize(location)
    @location = location
  end

  def title
    @location['title']
  end

  def subdomain
    @location['subdomain']
  end
  
  def asset_directory
    
  end
  
end
