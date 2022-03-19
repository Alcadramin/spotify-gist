# frozen_string_literal: true

require_relative "lib/spotify"
require_relative "lib/github"

class Main
  include GitHub
  include Spotify

  def initialize
    list = create_list
    auth
    update_gist(list)
  end
end

Main.new
