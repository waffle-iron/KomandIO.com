class GitReposController < ApplicationController

  def show
    @git_repo = GitRepo.find_by_repo_url(params[:id])
    @branches = @git_repo.git.github.branches(@git_repo.repo_url)
    @pull_requests = @git_repo.git.github.pull_requests(@git_repo.repo_url, state: 'open')
  end

  def create
    git = Git.new
    repo = git.create_github_repo params[:repo_url]

    redirect_to root_path, notice: "Repository(#{repo.repo_url}) successfully added"
  end
end