class GitRepo < ApplicationRecord
  before_destroy {|repo| repo.repo_path.rmtree if repo.repo_path.exist?}

  def repo_path
    git.home_path + repo_url
  end

  private
  def git
    @git ||= Git.new
  end
end
