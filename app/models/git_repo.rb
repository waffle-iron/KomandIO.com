class GitRepo < ApplicationRecord
  before_destroy do |repo|
    path = repo_path
    path.rmtree if path.exist?
  end

  def repo_path
    @repo_path ||= Git.new.repo_path(self.repo_url) 
  end

end
