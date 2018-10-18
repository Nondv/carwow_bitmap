# frozen_string_literal: true

require_relative 'bitmap'

class BitmapEditor
  class UnknownCommandError < StandardError; end
  class BadArgumentsError < StandardError; end

  COMMAND_MAP = { 'I' => :init_bitmap,
                  'L' => :color_pixel,
                  'S' => :print_bitmap }.freeze

  attr_reader :bitmap

  def execute_command(str)
    parts = str.split
    command = COMMAND_MAP[parts[0]]

    raise UnknownCommandError unless command
    args = parts[1..-1]
    send(command, args)
  end

  #
  # Commands.
  # **All** commands should have one parameter - `args`.
  #

  def init_bitmap(args)
    width = args[0]&.to_i || raise(BadArgumentsError)
    height = args[1]&.to_i || raise(BadArgumentsError)

    @bitmap = Bitmap.new(width, height)
  rescue ArgumentError
    raise BadArgumentsError
  end

  def print_bitmap(_args = nil)
    puts 'There is no image'
  end

  def color_pixel(args)
    x = args[0]&.to_i || raise(BadArgumentsError)
    y = args[1]&.to_i || raise(BadArgumentsError)
    color = args[2] || raise(BadArgumentsError)

    bitmap.draw_point(x, y, color)
  rescue ArgumentError
    raise BadArgumentsError
  end
end
