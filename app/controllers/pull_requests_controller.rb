class PullRequestsController < ApplicationController

  def show 
    github = Git.new.github
    @repo = params[:git_repo_id]
    number = params[:id]
    
    @pr       = github.pull_request(@repo, number)
    @commits  = github.pull_request_commits(@repo, number)
    @files    = github.pull_request_files(@repo, number)
  end
end
