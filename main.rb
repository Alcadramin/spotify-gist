# frozen_string_literal: true

require_relative "lib/utils"
require_relative "lib/spotify"
require_relative "lib/github"
include GitHub
include Spotify

list = Spotify.create_list
GitHub.update_gist(list)
