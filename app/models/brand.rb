require 'yaml'

class Brand

  @@brands = YAML::load_file('config/brands.yml')
  
  def self.configuration
    @@brands
  end
  
  def self.brands
    @@brands['brands']
  end

end
