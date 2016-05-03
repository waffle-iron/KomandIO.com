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
      @git.create_github_repo @repo_name
    end
  end

  def test_it_creates_github_repo_of_github_type
    repo = @git.create_github_repo @repo_name
    assert_equal 'github', repo.repo_type
    assert_equal @repo_name, repo.repo_url
  end

  def test_it_creates_repo_path_on_disk
    repo = @git.create_github_repo @repo_name
    assert_equal repo.repo_path.to_s, (@git.home_path + @repo_name).to_s
  end

  def test_it_creates_repo_path_when_provided_with_leading_slash
    repo = @git.create_github_repo "/" + @repo_name
    assert_equal repo.repo_path.to_s, (@git.home_path + @repo_name).to_s
  end

  def test_it_creates_repo_path_when_provided_with_spaces
    repo = @git.create_github_repo "  " + @repo_name + "   "
    assert_equal repo.repo_path.to_s, (@git.home_path + @repo_name).to_s
  end

  def test_it_creates_repo_as_absolute_path
    repo =  @git.create_github_repo @repo_name
    repo.repo_path.absolute?
  end

  def test_it_creates_repo_path_as_subpath_of_home_folder
    repo =  @git.create_github_repo @repo_name
    home = Pathname.new('~').expand_path
    assert repo.repo_path.relative_path_from home
  end

  def test_it_creates_directory_on_disk
    repo =  @git.create_github_repo @repo_name
    repo.repo_path.exist?
  end

  def test_it_creates_git_repo
    repo =  @git.create_github_repo @repo_name
    assert @git.git_working_tree?(repo.repo_path)
  end

end
