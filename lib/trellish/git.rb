require 'faraday'

module Trellish
  module Git

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
            body: "[Trello card](#{@card.url})",
            base: git_base_branch,
            head: "#{git_repository_owner}:#{current_git_branch}"
          }.to_json
        end
      rescue Faraday::Error::ConnectionFailed => e
        Trellish.logger.error "Failed to connect to Github. Please check your github_oauth_token parameter in trellish.yml, or regenerate it if you continue to have problems. Original error: #{e.message}"
        exit
      end
      if response.status == 401
        Trellish.logger.error "The response from the Github API says Bad Credentials. Please check your github_oauth_token parameter in trellish."
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

    def git_create_local_branch(branch_name)
      `git checkout -b #{branch_name} #{git_base_branch}`
    rescue
      Trellish.logger.warn "Failed to create a local git branch named #{branch_name}."
    end

    def current_git_branch_is_up_to_date?
      git_remote_up_to_date?(current_git_branch)
    end

    def git_user_initials
      return @user_initials if @user_initials
      username = presence(`git config github.user`) || presence(`git config user.email`) || presence(`whoami`)
      @user_initials = username[0..2]
    end

    def matches
      @matches ||= remote_url.match(%r|^git@github.com:([^/]*)\/([^\.]*)\.git$|)
    end

    def presence(s)
      s.strip if s && !s.strip.empty?
    end

    def remote_url
      @remote_url ||= `git config remote.origin.url`
    end

    private

    def current_git_branch
      @current_git_branch ||= `cat #{git_dir}/head`.split('/').last.strip
    end

    def git_base_branch
      Trellish.config[:git_base_branch]
    end

    def git_remote_up_to_date?(local_branch_name)
      remote_branch_name = git_remote_branch_for_local_branch(local_branch_name)

      local_hash = git_hash_for_ref("heads/#{local_branch_name}")
      remote_hash = git_hash_for_ref("remotes/#{remote_branch_name}")

      local_hash == remote_hash
    end

    def git_dir
      return @git_dir if @git_dir
      path = `git rev-parse --git-dir`.strip
      if path[/^fatal/]
        Trellish.logger.error "Failed to find your git repository."
        exit
      end
      @git_dir = path
    end

    def git_hash_for_ref(ref)
      `git show-ref --hash #{ref}`.strip
    end

    def git_remote_branch_for_local_branch(local_branch_name)
      `git for-each-ref --format='%(upstream:short)' refs/heads/#{local_branch_name}`.strip
    end

  end
end
