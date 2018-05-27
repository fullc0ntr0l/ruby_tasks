module Popcorn
  # Node class
  class Node
    attr_reader :id, :name, :links

    def initialize(id:, name:, links: [])
      @id = id
      @name = name
      @links = links
    end

    def add_link(link)
      @links << link
    end

    def link_ids
      @links.map(&:id)
    end

    def link_names
      @links.map(&:name)
    end
  end
end
