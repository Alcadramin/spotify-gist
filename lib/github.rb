# frozen_string_literal: true

require_relative "env"
require_relative "utils"
require "octokit"

module GitHub
  include Utils

  config = Env.new
  @@github_token = config.get_github[:gh_token]
  @@gist_id = config.get_github[:gist_id]
  @@gist_name = config.get_github[:gist_name]
  @@client = Octokit::Client

  def auth
    send_message("info", "Info(GitHub) :: Authorizing with GitHub..")
    client = Octokit::Client.new(access_token: @@github_token)
    user = client.user
    user.login

    send_message("success", "Success(GitHub) :: Successfully authorized with GitHub..")
    @@client = client
  rescue StandardError
    send_message("error", "Error(GitHub) :: Invalid access token..")
  end

  def verify_gist
    begin
      send_message("info", "Info(GitHub) :: Getting gist..")
      gist = @@client.gists.select { |entry| entry.id == @@gist_id }

      send_message("success", "Success(GitHub) :: Found gist at #{gist[0]["html_url"]}..")
    rescue StandardError
      send_message("error", "Error(GitHub) :: Can't find gist with given id..")
    end

    @@gist_name = nested_hash_value(gist, :description) if @@gist_name.empty?
    nested_hash_value(gist, :filename)
  end

  def update_gist(list)
    file = verify_gist

    begin
      send_message("info", "Info(GitHub) :: Creating gist content..")
      @@client.edit_gist(@@gist_id, {
                         files: { file => { "content": list } }
                       })

      send_message("success", "Success(GitHub) :: Successfully updated gist content..")
    rescue StandardError
      send_message("error", "Error(GitHub) :: Can't update gist content..")
    end
  end
end
