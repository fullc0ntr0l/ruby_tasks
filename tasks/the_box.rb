#!/usr/bin/env ruby
#
# Create a box class that can print out boxes in console.

# Box class
class Box
  DEFAULT_SYMBOL = '#'.freeze

  attr_reader :height, :width

  def initialize(height, width, fill_symbol = DEFAULT_SYMBOL)
    @height = height
    @width = width
    @fill_symbol = sanitize_symbol(fill_symbol)
  end

  def fill(sym = nil)
    @fill_symbol = sanitize_symbol(sym)
    self
  end

  def rotate
    @height, @width = @width, @height
    self
  end

  def resize(height = @height, width = @width)
    @height = height
    @width = width
    self
  end

  def expand(scale = 1)
    @height = (@height * scale).round
    @width = (@width * scale).round
    self
  end

  def print
    @height.times { puts (@fill_symbol * @width) }
    self
  end

  private

  def sanitize_symbol(sym)
    sym =~ /^\S$/ ? sym : DEFAULT_SYMBOL
  end
end

if $PROGRAM_NAME == __FILE__
  Box.new(3, 10).fill('#').rotate.resize(6, 25).expand(1.6).print
end
