#!/usr/bin/env ruby
#
# Create a module that lets you breed horses. Every animal should have a coat color.
# As a result provide a table of chances of possible coat colors based on parent color genes.
# It should have a class for horse, an error if a color doesn’t exist and a method for breeding horses.
# Check https://docs.google.com/document/d/1uRcadYcmkogWgbUM0FKWtmrr_fGRDcYYfijzjNzfRrk/edit doc for colors.
# 4p

# Horse class
class Horse
  COLORS = {
    AAtt: 'Alizarin crimson',
    AATt: 'Alloy orange',
    AATT: 'Almond',
    Aatt: 'Amaranth',
    AaTt: 'Amber',
    AaTT: 'Begonia',
    aatt: 'Bittersweet',
    aaTt: 'Blush',
    aaTT: 'Cadmium'
  }.freeze

  attr_reader :code

  def initialize(color)
    code = color_code(color)
    invalid_color(color) unless validate_code(code)

    @code = code
  end

  def breed(new_horse)
    combinations = code_combinations(self, new_horse)
    stats_hash = parse_combinations(combinations)
    output_result(stats_hash)
  end

  def a_value
    @code[0...2].chars
  end

  def t_value
    @code[2...4].chars
  end

  private

  def output_result(stats_hash)
    total = stats_hash.values.reduce(:+)

    stats_hash.each do |k, v|
      puts "#{COLORS[k]} (#{k}) - #{(v.to_f / total) * 100}%"
    end
  end

  def parse_combinations(combinations)
    combinations.reduce({}) do |result, combination|
      r = result.dup
      c_sym = combination.to_sym

      r[c_sym] = r.key?(c_sym) ? r[c_sym] + 1 : 1
      r
    end
  end

  def code_combinations(horse1, horse2)
    a_combinations = array_combination(horse1.a_value, horse2.a_value)
                     .map { |x| valid_subcode(x) }
    t_combinations = array_combination(horse1.t_value, horse2.t_value)
                     .map { |x| valid_subcode(x) }
    array_combination a_combinations, t_combinations
  end

  def array_combination(arr1, arr2)
    arr1.map { |x| arr2.reduce([]) { |res, y| res + [x + y] } }.flatten
  end

  def valid_subcode(subcode)
    subcode[0] > subcode[-1] ? subcode[-1] + subcode[0] : subcode
  end

  def color_code(color)
    color_sym = color.to_sym
    return color_sym if COLORS.key?(color_sym)

    color_pair = COLORS.find { |_, v| v == color.capitalize }
    color_pair ? color_pair[0] : invalid_color(color)
  end

  def validate_code(code)
    code =~ /^(aa|AA|Aa)(tt|TT|Tt)$/
  end

  def invalid_color(color)
    raise <<-HEREDOC
      Invalid color '#{color}'
      Use following colors: #{COLORS.values.join(', ')}
      Or according shortcuts: #{COLORS.keys.join(', ')}
    HEREDOC
  end
end

##############
# Start here #
##############
first_color = ARGV.shift
second_color = ARGV.shift

unless first_color && second_color
  abort_message = <<-HEREDOC
    You need to provide colors for two horses
    Usage: #{__FILE__} color1 color2
    Available colors: #{Horse::COLORS.values.join(', ')}
  HEREDOC

  abort abort_message
end

begin
  Horse.new(first_color).breed Horse.new(second_color)
rescue StandardError => e
  abort e.message
end
