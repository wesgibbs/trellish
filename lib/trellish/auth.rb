require 'trello'

module Trellish

  class Auth
    include Trello
    include Trello::Authorization

    Trello::Authorization.const_set :AuthPolicy, OAuthPolicy

    def self.authorize
      OAuthPolicy.consumer_credential = OAuthCredential.new(
        Trellish.config[:trello_api_key],
        Trellish.config[:trello_oauth_secret])
      OAuthPolicy.token = OAuthCredential.new(Trellish.config[:trello_oauth_token], nil)

      # Test that the user is authorized
      begin
        member_id = Trello::Token.find(OAuthPolicy.token.key).member_id
        Member.find(member_id)
      rescue
        Trellish.logger.error "Unable to authorize access to Trello API."
        exit
      end
    end

  end
end
