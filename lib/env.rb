require 'dotenv'
Dotenv.load(
  File.expand_path("../.env", File.dirname(__FILE__))
)

class Env
  def initialize()
    @spotify_client_id = ENV['SPOTIFY_CLIENT_ID']
    @spotify_client_secret = ENV['SPOTIFY_CLIENT_SECRET']
    @spotify_refresh_token = ENV['SPOTIFY_REFRESH_TOKEN']
    @github_secret = ENV['GITHUB_SECRET']
    @gist_id = ENV['GIST_ID']
    @length = ENV['LENGTH'] || 20
  end
end
