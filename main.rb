require_relative "lib/spotify.rb"
include Spotify

tracks = Spotify.get_tracks
