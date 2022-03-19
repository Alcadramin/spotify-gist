# frozen_string_literal: true

require_relative "env"
require_relative "cli"
require "octokit"

module GitHub
  include Cli

  config = Env.new
  @github_token = config.get_github[:gh_token]
  @gist_id = config.get_github[:gist_id]

  def auth
    send_message("info", "Info(GitHub) :: Authorizing with GitHub..")
    client = Octokit::Client.new(access_token: @github_token)
    user = client.user
    user.login

    send_message("success", "Success(GitHub) :: Successfully authorized with GitHub..")
    client
  rescue StandardError
    send_message("error", "Error(GitHub) :: Invalid access token..")
  end

  def gist
    client = auth

    begin
      send_message("info", "Info(GitHub) :: Getting gist..")
      gist = client.gist(@gist_id)

      send_message("success", "Success(GitHub) :: Found gist at #{gist.html_url}..")
    rescue StandardError
      send_message("error", "Error(GitHub) :: Can't find gist with given id..")
    end
  end
end
