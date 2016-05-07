require 'test_helper'

class GitReposIntegrationTest < ActionDispatch::IntegrationTest

  teardown do
    GitRepo.all.each do |repo|
      repo.destroy
    end 
  end

  def test_it_creates_new_repos
    assert_difference "GitRepo.count" do 
      post git_repos_path, params: {repo_url: 'netoff/ruby-rails-sample', repo_type: 'github'}
    end

    assert_redirected_to root_path
    assert_equal "Repository(netoff/ruby-rails-sample) successfully added", flash[:notice]

    visit root_path
    assert_text("Github Repositories")

    within "[data-repo='netoff/prose']" do
      assert_selector "input[value='Clone']"
    end

    within "[data-repo='netoff/ruby-rails-sample']" do
      assert_no_selector "input[value='Clone']"
    end
  end

  def test_it_can_display_repo_its_branches_and_pull_requests
    repo_name = 'netoff/ruby-rails-sample'
    post git_repos_path, params: {repo_url: repo_name, repo_type: 'github'}
    visit root_path

    within "[data-repo='#{repo_name}']" do
      click_on "View"
    end    

    assert_text repo_name

    within "#branches" do 
      assert_text "test-branch"
    end

    within "#pull_requests" do 
      assert_text "Test PR"
    end
  end

  def test_it_displays_pull_request
    repo_name = 'netoff/ruby-rails-sample'
    post git_repos_path, params: {repo_url: repo_name, repo_type: 'github'}
    visit root_path

    #open 'ruby-rails-sample' path
    within "[data-repo='#{repo_name}']" do
      click_on "View"
    end   

    within "#pull_requests" do 
      click_on "Test PR"
    end

    assert_current_path git_repo_pull_request_path(git_repo_id: repo_name, id: '1')
    assert_text 'Test PR'

    within "#commits" do 
      assert_text "test 1"
      assert_text "test 2"
    end

    within "#files" do 
      assert_text "test.txt"
    end
  end
end