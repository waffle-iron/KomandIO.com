require 'test_helper'

class GitTest < ActiveSupport::TestCase
  setup do 
    @git = Git.new
    @repo_name = 'netoff/ruby-rails-sample'
  end

  teardown do
    #remove all local repos
    GitRepo.all.each do |repo|
      repo.destroy
    end 
  end

  def test_there_is_home_path
    assert @git.home_path.exist?
  end

  def test_home_path_is_writable
    assert @git.home_path.writable?
  end

  def test_it_creates_github_repo
    assert_difference 'GitRepo.count' do
      @git.get_github_repo @repo_name
    end
  end

  def test_it_gets_repo_if_it_is_already_there
    repo = git_repos(:existing)
    
    assert_no_difference 'GitRepo.count' do 
      assert_equal @git.get_github_repo(repo.repo_url), repo
    end
  end

  def test_it_creates_github_repo_of_github_type
    repo = @git.get_github_repo @repo_name
    assert_equal 'github', repo.repo_type
    assert_equal @repo_name, repo.repo_url
  end

  def test_it_creates_repo_path_on_disk
    repo = @git.get_github_repo @repo_name
    assert_equal repo.repo_path.to_s, (@git.home_path + @repo_name).to_s
  end

  def test_it_creates_repo_path_when_provided_with_leading_slash
    repo = @git.get_github_repo "/" + @repo_name
    assert_equal repo.repo_path.to_s, (@git.home_path + @repo_name).to_s
  end

  def test_it_creates_repo_path_when_provided_with_spaces
    repo = @git.get_github_repo "  " + @repo_name + "   "
    assert_equal repo.repo_path.to_s, (@git.home_path + @repo_name).to_s
  end

  def test_it_creates_repo_as_absolute_path
    repo =  @git.get_github_repo @repo_name
    repo.repo_path.absolute?
  end

  def test_it_creates_repo_path_as_subpath_of_home_folder
    repo =  @git.get_github_repo @repo_name
    home = Pathname.new('~').expand_path
    assert repo.repo_path.relative_path_from home
  end

  def test_it_creates_directory_on_disk
    repo =  @git.get_github_repo @repo_name
    repo.repo_path.exist?
  end

  def test_it_creates_git_repo
    repo =  @git.get_github_repo @repo_name
    assert @git.git_working_tree?(repo.repo_path.to_s)
  end

  def test_it_has_proper_git_credentials
    assert @git.send(:git_privatekey).exist?
    assert @git.send(:git_publickey).exist?
    assert_equal ".pub", @git.send(:git_publickey).extname
  end

  def test_it_returns_list_of_branches
    assert @git.github.respond_to? :branches
  end

  def test_it_returns_list_of_pull_requests
    assert @git.github.respond_to? :pull_requests
  end

  def test_it_returns_list_of_pull_commits
    assert @git.github.respond_to? :pull_commits
  end

  def test_it_returns_list_of_pull_files
    assert @git.github.respond_to? :pull_request_files
  end

end


