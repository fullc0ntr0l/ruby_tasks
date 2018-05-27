# This reader parse a YAML file for valid nodes and links
require 'yaml'

module SourceReaders
  # Yaml class
  class Yaml < Base
    def initialize(yaml_file: nil)
      validate_file yaml_file
      @yaml_file = yaml_file
    end

    def load
      data = YAML.load_file(@yaml_file)
      validate_network(data)
      data
    end
  end
end
