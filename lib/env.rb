# frozen_string_literal: true

require_relative "utils"
require "dotenv"
Dotenv.load(
  File.expand_path("../.env", File.dirname(__FILE__))
)

class Env
  include Utils

  def initialize
    @list_format = ENV["LIST_FMT"] || ''
    @spotify_client_id = ENV["SPOTIFY_CLIENT_ID"]
    @spotify_client_secret = ENV["SPOTIFY_CLIENT_SECRET"]
    @spotify_refresh_token = ENV["SPOTIFY_REFRESH_TOKEN"]
    @github_token = ENV["GH_TOKEN"]
    @gist_id = ENV["GIST_ID"]
    @gist_name = ENV["GIST_NAME"] || ''
    @length = (ENV["LENGTH"] || '').empty? ? 20 : ENV["LENGTH"]
    @time = (ENV["TIME"] || '').empty? ? "short_term" : ENV["TIME"]
  end

  def get_list_format
    @list_format.to_s
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
      gist_id: @gist_id,
      gist_name: @gist_name
    }
  end
end
