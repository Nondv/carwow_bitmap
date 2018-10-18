# frozen_string_literal: true

class BitmapEditor
  class UnknownCommandError < StandardError; end

  COMMAND_MAP = { 'S' => :print_bitmap }.freeze

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

  def print_bitmap(_args = nil)
    puts 'There is no image'
  end
end
