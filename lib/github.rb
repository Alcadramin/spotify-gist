# frozen_string_literal: true

require_relative "env"
require "octokit"

module GitHub
  config = Env.new
  @github_token = config.get_github[:gh_token]
  @gist_id = config.get_github[:gist_id]
end
