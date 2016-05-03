class GithubReposController < ApplicationController


  def index
    user = 'netoff'
    
    @git = Git.new
    @repositories = @git.client.repositories(user)
  end
end