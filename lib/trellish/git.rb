module Trellish
  module Git

    def current_git_branch
      @current_git_branch ||= `cat .git/head`.split('/').last
    end

    def github_branch_url
      @github_branch_url ||= "https://github.com/#{git_repository_owner}/#{git_repository_name}/tree/#{current_git_branch}"
    end

    def remote_url
      @remote_url ||= `git config remote.origin.url`
    end

    def matches
      @matches ||= matches = remote_url.match(%r|^git@github.com:([^/]*)\/([^\.]*)\.git$|)
    end

    def git_repository_owner
      @git_repository_owner ||= matches[1]
    end

    def git_repository_name
      @git_repository_name ||= matches[2]
    end

  end
end
