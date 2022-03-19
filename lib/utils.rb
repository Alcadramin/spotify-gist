# frozen_string_literal: true

require "colorize"

module Utils
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

  def nested_hash_value(obj, key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=nested_hash_value(a.last,key) }
      r
    end
  end
end
