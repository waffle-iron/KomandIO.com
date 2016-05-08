class GitReposController < ApplicationController

  def show
    @repo_url = params[:id]
    # @git_repo = GitRepo.find_by_repo_url(repo_ur)
    
    git = Git.new
    @branches = git.github.branches(@repo_url)
    @pull_requests = git.github.pull_requests(@repo_url, state: 'open')
  end
end