# frozen_string_literal: true

require_relative "cli"
require "dotenv"
Dotenv.load(
  File.expand_path("../.env", File.dirname(__FILE__))
)

class Env
  include Cli

  def initialize
    @spotify_client_id = ENV["SPOTIFY_CLIENT_ID"]
    @spotify_client_secret = ENV["SPOTIFY_CLIENT_SECRET"]
    @spotify_refresh_token = ENV["SPOTIFY_REFRESH_TOKEN"]
    @github_token = ENV["GITHUB_TOKEN"]
    @gist_id = ENV["GIST_ID"]
    @length = ENV["LENGTH"].empty? ? 20 : ENV["LENGTH"]
    @time = ENV["TIME"].empty? ? "short_term" : ENV["TIME"]
  end

  def get_spotify
    if (@spotify_client_id || '').empty? || (@spotify_client_secret || '').empty? || (@spotify_refresh_token || '').empty?
      send_message("error", "Error(Spotify) :: Missing credentials..")
    end

    {
      client_id: @spotify_client_id,
      client_secret: @spotify_client_secret,
      refresh_token: @spotify_refresh_token,
      length: @length,
      time: @time
    }
  end

  def get_github
    if (@github_token || '').empty? || (@gist_id || '').empty?
      send_message("error", "Error(GitHub) :: Missing credentials..")
    end

    {
      gh_token: @github_token,
      gist_id: @gist_id
    }
  end
end
