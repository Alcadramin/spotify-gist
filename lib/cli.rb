# frozen_string_literal: true

require "colorize"

module Cli
  def send_message(type, message)
    case type
    when 'error'
      message.colorize(:red)
    when 'info'
      message.colorize(:light_blue)
    when 'success'
      message.colorize(:green)
    else
      puts "Error(Cli) :: Wrong message type".colorize(:red)
      exit!
    end
  end
end
