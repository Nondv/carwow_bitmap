# frozen_string_literal: true

#
# Class that encapsulates data and provides methods
# for mutating it. Boundaries are NOT mutable
#
class Bitmap
  class InvalidColorError < StandardError; end

  attr_reader :width, :height

  def initialize(width, height, init_color = convert_color('O'))
    validate_width_and_height(width, height)

    @width = width
    @height = height

    # using 1D array decreases some stupid link-related errors
    # @data = Array.new(width) { Array.new(height) }
    @data = Array.new(width * height, init_color)
  end

  def [](x, y)
    @data[coordinates_to_index(x, y)]
  end

  def draw_point(x, y, color)
    @data[coordinates_to_index(x, y)] = convert_color(color)
  end

  def draw_rectangle(x1, y1, x2, y2, color)
    # convert points to more comfortable format
    # (take top-left and bottom-right)
    x1, x2 = x2, x1 if x1 > x2
    y1, y2 = y2, y1 if y1 > y2

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        draw_point(x, y, color)
      end
    end
  end

  def to_a
    Array.new(height) do |i|
      y = i + 1
      Array.new(width) { |j| self[j + 1, y] }
    end
  end

  private

  # Right now it just validates input.
  # Later it should be used for data conversion.
  # I guess it's better to use symbols for storing colors
  def convert_color(color)
    raise InvalidColorError unless color.is_a?(String) && color =~ /^[A-Z]$/
    color
  end

  # Never convert manually, always use this method
  # or you risk getting math errors
  def coordinates_to_index(x, y)
    raise ArgumentError if x < 1 || y < 1
    raise ArgumentError if x > width || y > height
    # minus one since we start coordinates from (1; 1)
    (y - 1) * width + (x - 1)
  end

  private

  def validate_width_and_height(width, height)
    [width, height].each do |n|
      raise ArgumentError unless n.is_a?(Integer) &&
                                 (1..250).cover?(n)
    end
  end
end
