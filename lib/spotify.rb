# frozen_string_literal: true

require_relative "env"
require_relative "cli"
require "faraday"
require "faraday/net_http"
require "json"

module Spotify
  include Cli

  config = Env.new
  @client_id = config.get_spotify[:client_id]
  @client_secret = config.get_spotify[:client_secret]
  @refresh_token = config.get_spotify[:refresh_token]
  @length = config.get_spotify[:length]
  @time = config.get_spotify[:time]

  @get_token_uri = "https://accounts.spotify.com/api/token"
  @get_tracks_uri = "https://api.spotify.com/v1/me/top/tracks"

  def get_access_token
    puts send_message("info", "Info(Spotify) :: Getting access token..")

    conn = Faraday.new(
      url: @get_token_uri
    ) do |builder|
      builder.response :json
      builder.use Faraday::Request::Retry
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Request::BasicAuthentication, @client_id, @client_secret
      builder.adapter Faraday::Adapter::NetHttp
    end

    response = conn.post() do |req|
      req.body = { grant_type: "refresh_token", refresh_token: @refresh_token }
    end

    response.body["access_token"]
  end

  def get_tracks
    puts send_message("info", "Info(Spotify) :: Getting tracks..")

    access_token = get_access_token

    if access_token.nil? || access_token.empty?
      puts send_message("error", "Error(Spotify) :: Access token didn't acquired..")
      exit!
    else
      puts send_message("success", "Success(Spotify) :: Access token acquired..")
    end

    conn = Faraday.new(
      url: @get_tracks_uri
    ) do |builder|
      builder.response :json
      builder.use Faraday::Request::Retry
      builder.use Faraday::Request::Authorization, "Bearer", access_token
      builder.adapter Faraday::Adapter::NetHttp
    end

    response = conn.get() do |req|
      req.params["limit"] = @length
      req.params["time_range"] = @time
    end

    response.body["items"]
  end
end
