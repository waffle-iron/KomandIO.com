class GithubReposController < ApplicationController


  def index
    user = 'netoff'

    @git = Git.new
    @repositories = @git.github.repositories(user)
  end
end