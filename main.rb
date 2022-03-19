# frozen_string_literal: true

require_relative "lib/cli"
require_relative "lib/spotify"
require_relative "lib/github"
include Cli
include Spotify
include GitHub

tracks = Spotify.get_tracks

if tracks.size.zero? || tracks.empty?
  send_message("error", "Error(Spotify) :: Can't find tracks..")
else
  send_message("success", "Success(Spotify) :: Found tracks..")
end
