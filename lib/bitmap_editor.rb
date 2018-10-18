# frozen_string_literal: true

require_relative 'bitmap'

class BitmapEditor
  class UnknownCommandError < StandardError; end
  class BadArgumentsError < StandardError; end

  COMMAND_MAP = { 'I' => :init_bitmap,
                  'L' => :color_pixel,
                  'V' => :color_vertical_line,
                  'H' => :color_horizontal_line,
                  'S' => :print_bitmap }.freeze

  attr_reader :bitmap

  def execute_command(str)
    parts = str.split
    command = COMMAND_MAP[parts[0]]

    raise UnknownCommandError unless command
    args = parts[1..-1]
    send(command, args)

  # TODO: better to create error type like Bitmap::ArgumentFormatError
  #       because this way we may supress stupid source code errors.
  #       For example, we can forget to add parameter to new command
  #       and call itself will raise ArgumentError
  rescue ArgumentError
    raise BadArgumentsError
  end

  #
  # Commands.
  # **All** commands should have one parameter - `args`.
  #

  def init_bitmap(args)
    width, height = parse_parameters(args, :int, :int)
    @bitmap = Bitmap.new(width, height)
  end

  def print_bitmap(_args = nil)
    puts 'There is no image'
  end

  def color_pixel(args)
    x, y, color = parse_parameters(args, :int, :int, :color)
    bitmap.draw_point(x, y, color)
  end

  def color_vertical_line(args)
    x, y1, y2, color = parse_parameters(args, :int, :int, :int, :color)
    bitmap.draw_rectangle(x, y1, x, y2, color)
  end

  def color_horizontal_line(args)
    x1, x2, y, color = parse_parameters(args, :int, :int, :int, :color)
    bitmap.draw_rectangle(x1, y, x2, y, color)
  end

  private

  # by given types returns corresponding values
  # with conversion and validation (raises BadArgumentsError)
  # Available types are:
  # * :int
  # * :color
  #
  # @example parse_parameters(['1', '15', 'C'], :int, :int, :color
  def parse_parameters(arguments, *types)
    result = Array.new(types.size)
    types.each_with_index do |t, i|
      arg = arguments[i] || raise(BadArgumentsError)

      result[i] = case t
                  when :int then int_parameter(arg)
                  when :color then color_parameter(arg)
                  end
    end
    result
  end

  def int_parameter(arg)
    raise BadArgumentsError unless arg.is_a?(Integer) || arg =~ /^\d+$/
    arg.to_i
  end

  def color_parameter(arg)
    arg.size == 1 ? arg : raise(BadArgumentsError)
  end
end
