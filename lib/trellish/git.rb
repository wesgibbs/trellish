require 'faraday'

module Trellish
  module Git

    def current_git_branch
      @current_git_branch ||= `cat .git/head`.split('/').last.strip
    end

    def github_pull_request_url
      return @github_pull_request_url if @github_pull_request_url
      conn = Faraday.new(:url => 'https://api.github.com', :ssl => {:ca_file => '/System/Library/OpenSSL/certs/ca-certificates.crt'}) do |faraday|
        faraday.request :url_encoded
        faraday.adapter ::Faraday.default_adapter
      end
      begin
        response = conn.post do |req|
          req.url "/repos/#{git_repository_owner}/#{git_repository_name}/pulls"
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "token #{Trellish.config[:github_oauth_token]}"
          req.body = {
            title: @card.name,
            base: Trellish.config[:git_base_branch],
            head: "#{git_repository_owner}:#{current_git_branch}"
          }.to_json
        end
      rescue Faraday::Error::ConnectionFailed => e
        Trellish.logger.error "Failed to connect to Github. Please check your github_oauth_token parameter in trellish.yml, or regenerate it if you continue to have problems. Original error: #{e.message}"
        exit
      end
      @github_pull_request_url = JSON.parse(response.body)["html_url"]
    end

    def git_repository_name
      @git_repository_name ||= matches[2]
    end

    def git_repository_owner
      @git_repository_owner ||= matches[1]
    end

    def matches
      @matches ||= matches = remote_url.match(%r|^git@github.com:([^/]*)\/([^\.]*)\.git$|)
    end

    def remote_url
      @remote_url ||= `git config remote.origin.url`
    end

  end
end
