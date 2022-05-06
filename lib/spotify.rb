# frozen_string_literal: true

require_relative "env"
require_relative "utils"
require "faraday"
require "faraday/net_http"
require "json"
require "unicode/display_width/string_ext"

module Spotify
  include Utils

  config = Env.new
  @@client_id = config.get_spotify[:client_id]
  @@client_secret = config.get_spotify[:client_secret]
  @@refresh_token = config.get_spotify[:refresh_token]
  @@length = config.get_spotify[:length]
  @@time = config.get_spotify[:time]
  @@list_format = config.get_list_format

  @@get_token_uri = "https://accounts.spotify.com/api/token"
  @@get_tracks_uri = "https://api.spotify.com/v1/me/top/tracks"

  def get_access_token
    send_message("info", "Info(Spotify) :: Getting access token..")

    conn = Faraday.new(
      url: @@get_token_uri,
    ) do |builder|
      builder.response :json
      builder.use Faraday::Request::Retry
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Request::BasicAuthentication, @@client_id, @@client_secret
      builder.adapter Faraday::Adapter::NetHttp
    end

    response = conn.post() do |req|
      req.body = { grant_type: "refresh_token", refresh_token: @@refresh_token }
    end

    response.body["access_token"]
  end

  def get_tracks
    send_message("info", "Info(Spotify) :: Getting tracks..")

    access_token = get_access_token

    if access_token.nil? || access_token.empty?
      send_message("error", "Error(Spotify) :: Access token didn't acquired..")
    else
      send_message("success", "Success(Spotify) :: Access token acquired..")
    end

    conn = Faraday.new(
      url: @@get_tracks_uri,
    ) do |builder|
      builder.response :json
      builder.use Faraday::Request::Retry
      builder.use Faraday::Request::Authorization, "Bearer", access_token
      builder.adapter Faraday::Adapter::NetHttp
    end

    response = conn.get() do |req|
      req.params["limit"] = @@length
      req.params["time_range"] = @@time
    end

    response.body["items"]
  end

  def parse_tracks
    tracks = get_tracks

    if tracks.size.zero? || tracks.empty?
      send_message("error", "Error(Spotify) :: Can't find tracks..")
    else
      send_message("success", "Success(Spotify) :: Found tracks..")
    end

    parsed = tracks.map do |track|
      {
        artist: track["artists"][0]["name"],
        name: track["name"],
      }
    end

    send_message("error", "Error(Spotify) :: Error while parsing tracks..") if parsed.empty?

    parsed.map do |q|
      {
        artist: q[:artist].to_s[0..19],
        name: q[:name].to_s[0..25],
      }
    end
  end

  def create_list
    tracks = parse_tracks

    send_message("info", "Info(Spotify) :: Using list format #{@@list_format}.")

    if @@list_format == '1'
      list = tracks.map do |track|
        "#{track[:name].ljust(34 + track[:name].size - track[:name].display_width)}#{track[:artist].rjust(20 + track[:artist].size - track[:artist].display_width)}"
      end
    elsif @@list_format == '2'
      list = tracks.map do |track|
        "「#{track[:name]} — #{track[:artist]}」"
      end
    elsif @@list_format == '3'
      list = tracks.map do |track|
        "【#{track[:name]} — #{track[:artist]}】"
      end
    elsif @@list_format == '4'
      list = tracks.map do |track|
        "『#{track[:name]} — #{track[:artist]}』"
      end
    else
      list = tracks.map do |track|
        "#{track[:name]} — #{track[:artist]}"
      end
    end

    list.join("\n")
  end
end
