# frozen_string_literal: true

#
# Class that encapsulates data and provides methods
# for mutating it. Boundaries are NOT mutable
#
class Bitmap
  attr_reader :width, :height

  def initialize(width, height, init_color = 'O')
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

  private

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
