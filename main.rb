# frozen_string_literal: true

require_relative "lib/spotify.rb"
include Spotify

tracks = Spotify.get_tracks
