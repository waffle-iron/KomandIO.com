require 'test_helper'

class GitRepoTest < ActiveSupport::TestCase
  
  setup do 
    @git = Git.new
    @repo_name = 'netoff/ruby-rails-sample'
  end

  teardown do 
    GitRepo.all.each do |repo|
      repo.destroy
    end
  end

  def test_it_cleans_up_after_itself
    @repo =  @git.get_github_repo @repo_name

    repo_path = @repo.repo_path
    assert repo_path.exist?

    @repo.destroy
    refute repo_path.exist?
  end

  def test_it_knows_if_repo_alredy_exist_on_system
    existing = git_repos(:existing)
    assert GitRepo.exists?(repo_url: existing.repo_url)
    assert GitRepo.where(repo_url: existing.repo_url).exists?
  end
end
