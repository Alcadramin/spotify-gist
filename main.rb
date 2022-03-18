# frozen_string_literal: true

require_relative "lib/spotify"
include Spotify

tracks = Spotify.get_tracks
puts tracks
