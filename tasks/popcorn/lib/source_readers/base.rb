# Source readers include a few classes that reads network definition
# from  a particular source, for example, yaml or json file

module SourceReaders
  # Base class
  class Base
    def self.load_data(params = {})
      instance = new(params)
      instance.load
    end

    private

    #
    # Validate methods
    #

    def validate_file(file_path)
      unless file_path.is_a?(String) && !file_path.empty?
        raise 'Invalid source file value.'
      end

      return if File.exist?(file_path)

      raise "Cannot find source file - #{file_path}."
    end

    # Check for correct configuration of source
    # Data should be an Hash with following format:
    # {
    #   "nodes" => {
    #     "node1" => "a",
    #     "node2" => "b",
    #     ...
    #   },
    #   "links" => {
    #     "link1" => ["node1", "node2"],
    #     "link2" => ["node10", "node7"],
    #     ...
    #   }
    # }
    def validate_network(data)
      unless data.is_a?(Hash)
        raise "Invalid network type: '#{data.class}'. Should be of type Hash"
      end

      validate_config(data, 'nodes', String)
      validate_config(data, 'links', Array)

      data['links'].each do |k, v|
        validate_link(k, v, data['nodes'].keys)
      end
    end

    def validate_config(data, key, value_type)
      validate_key(data, key)

      keys = data[key].keys
      keys.each do |k|
        validate_key(data[key], k, value_type, [key])
      end

      validate_unique_ids(keys, key)
    end

    def validate_link(link_id, link, node_ids)
      error_msg = "Invalid value for link '#{link_id}'."

      if link.length != 2
        raise "#{error_msg} You should set and array of TWO node ids."
      end

      raise "#{error_msg} Array with duplicte values." if link[0] == link[1]

      link.each do |node_id|
        next if node_ids.include?(node_id)

        raise "#{error_msg} Node with id '#{node_id}' not found"
      end
    end

    def validate_key(object, key, type = Hash, parrent_keys = [])
      nested_key = (parrent_keys + [key]).join('.')

      unless object.key?(key)
        raise "Can't find '#{nested_key}' key inside network data source."
      end

      value_type = object[key].class

      return if value_type == type

      raise "Invalid #{nested_key} key type: '#{value_type}'."\
            " Should be of type #{type}."
    end

    def validate_unique_ids(ids, parrent_key)
      uniq_ids = ids.uniq
      return if ids.length == uniq_ids.length

      duplicate_keys = ids - uniq_ids

      raise "Found duplicate '#{parrent_key}' ids: #{duplicate_keys.join(', ')}"
    end

    #
    # End of validate methods
    #
  end
end
