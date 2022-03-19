# frozen_string_literal: true

require "colorize"

module Cli
  def send_message(type, message)
    case type
    when 'error'
      puts message.colorize(:red)
      exit!
    when 'info'
      puts message.colorize(:light_blue)
    when 'success'
      puts message.colorize(:green)
    else
      puts "Error(Cli) :: Wrong message type".colorize(:red)
      exit!
    end
  end
end
