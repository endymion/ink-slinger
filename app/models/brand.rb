require 'yaml'

class Brand

  @@brands = YAML::load_file('config/brands.yml')
  
  def self.configuration
    @@brands
  end
  
  def self.brands
    @@brands['brands']
  end

  def self.asset_hosts
    brands.map { |brand|
      brand['locations'].map {|location|
        unless location['subdomain'].eql? 'www'
          (0..3).to_a.map {|index| location['subdomain'] + "-#{index}." + brand['assets'] }.flatten
        else
          brand['assets']
        end
      }
    }.flatten
  end

  def self.application_hosts
    # The base brand domain name.
    hosts = Brand.brands.map {|brand| brand['host']}

    # Add all brand subdomains.
    hosts += Brand.brands.map { |brand|
      brand['locations'].map {|location| location['subdomain'] + '.' + brand['host']}
    }.flatten
  end

end
