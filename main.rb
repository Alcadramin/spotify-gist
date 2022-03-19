# frozen_string_literal: true

require_relative "lib/cli"
require_relative "lib/spotify"
include Cli
include Spotify

tracks = Spotify.get_tracks

if tracks.size.zero? || tracks.empty?
  puts send_message("error", "Error(Spotify) :: Can't find tracks..")
  exit!
else
  puts send_message("success", "Success(Spotify) :: Found tracks..")
end
