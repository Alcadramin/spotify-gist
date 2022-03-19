# frozen_string_literal: true

require_relative "lib/cli"
require_relative "lib/spotify"
include Cli
include Spotify

tracks = Spotify.get_tracks

if tracks.size.zero? || tracks.empty?
  send_message("error", "Error(Spotify) :: Can't find tracks..")
else
  send_message("success", "Success(Spotify) :: Found tracks..")
end
