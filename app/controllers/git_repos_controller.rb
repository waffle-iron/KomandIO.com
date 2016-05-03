class GitReposController < ApplicationController

  def create
    git = Git.new
    repo = git.create_github_repo params[:repo_url]

    redirect_to root_path, notice: "Repository(#{repo.repo_url}) successfully added"
  end
end