require 'json'
require 'addressable/uri'
require 'oauth'
require 'launchy'
require 'yaml'



class TwitterSession

  TOKEN_FILE = "access_token.yml"

  CONSUMER_KEY = "P1pJk6UHS7gQ6qOmAvVXA"
  CONSUMER_SECRET = "cWlEwDN4jUiJ46y8FAwmv8X9wd9Ia6ablfblh5SA"

  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def self.get(path, query_values)
    url = TwitterSession.path_to_url(path, query_values)
    p url
    # puts url.to_s
    JSON.parse(self.access_token.get(url.to_s).body)
  end

  def self.post(path, reg_params)
    url = TwitterSession.path_to_url(path)
    JSON.parse(self.access_token.post(url.to_s, reg_params).body)
  end

  def self.access_token
    if File.exist?(TOKEN_FILE)
        # reload token from file
      @access_token ||= File.open(TOKEN_FILE) { |f| YAML.load(f) }
    else
      # copy the old code that requested the access token into a
      # `request_access_token` method.
      @access_token ||= TwitterSession.request_access_token
      File.open(TOKEN_FILE, "w") { |f| YAML.dump(access_token, f) }

      @access_token
    end
  end

  def self.request_access_token


    # Ask service for a URL to send the user to so that they may authorize
    # us.
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    # Launchy is a gem that opens a browser tab for us
    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    # Because we don't use a redirect URL; user will receive a short PIN
    # (called a **verifier**) that they can input into the client
    # application. The client asks the service to give them a permanent
    # access token to use.
    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp
    request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
  end

  def self.path_to_url(path, query_values = nil)
    uri = Addressable::URI.new(
    :scheme => 'https',
    :host => 'api.twitter.com',
    :path => "1.1/#{path}.json",
    :query_values => query_values
    )
  end

end


