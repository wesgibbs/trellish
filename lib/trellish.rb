require 'logger'
require 'trellish/auth'
require 'trellish/card'
require 'trellish/git'
require 'trellish/version'
require 'trello'

module Trellish

  @config = {
    trello_api_key: 'TRELLO_API_KEY',
    trello_oauth_secret: 'TRELLO_OAUTH_SECRET',
    trello_oauth_token: 'TRELLO_OAUTH_TOKEN',
    github_oauth_token: 'GITHUB_OAUTH_TOKEN'
  }

  @valid_config_keys = @config.keys

  def self.configure(params = {})
    params.each { |k, v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  def self.config
    @config
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

end
