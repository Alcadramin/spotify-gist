# frozen_string_literal: true

require_relative "lib/cli"
require_relative "lib/spotify"
require_relative "lib/github"
include Cli
include Spotify
include GitHub
