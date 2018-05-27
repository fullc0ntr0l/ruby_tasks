module Popcorn
  # Network class
  class Network
    def initialize(source_reader:)
      @data = source_reader.load
      @nodes = generate_nodes

      add_nodes_links
    end

    def words(min_length = 1)
      parse_path(nodes: @nodes, min_length: min_length).uniq
    end

    private

    def generate_nodes
      @data['nodes'].each.map do |node_id, node_name|
        Popcorn::Node.new(id: node_id, name: node_name)
      end
    end

    def add_nodes_links
      @nodes.each do |node|
        get_node_links(node.id).each do |link_id|
          link_node = find_node_by_id(link_id)

          node.add_link(link_node) if link_node
        end
      end
    end

    def get_node_links(node_id)
      links = []
      @data['links'].each do |_, v|
        link = v.dup
        links << link.first if link.delete(node_id)
      end
      links.compact.uniq
    end

    def find_node_by_id(node_id)
      @nodes.find { |n| n.id == node_id }
    end

    # rubocop:disable Metrics/MethodLength
    def parse_path(nodes:, min_length:, used_nodes: [])
      w = []
      if !used_nodes.empty? && used_nodes.length >= min_length
        w << generate_word(used_nodes)
      end

      nodes.reduce(w) do |words, node|
        if used_nodes.include?(node)
          words
        else
          parse_path(
            nodes: node.links,
            min_length: min_length,
            used_nodes: used_nodes + [node]
          ) + words
        end
      end
    end
    # rubocop:enable Metrics/MethodLength

    def generate_word(nodes_list)
      nodes_list.map(&:name).join
    end
  end
end
