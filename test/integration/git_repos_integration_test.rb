require 'test_helper'

class GitReposIntegrationTest < ActionDispatch::IntegrationTest

  teardown do
    GitRepo.all.each do |repo|
      repo.destroy
    end 
  end

  def test_it_can_display_repo_its_branches_and_pull_requests
    repo_name = 'netoff/ruby-rails-sample'
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

  def test_it_squashes_commits
  end

  def test_it_deletes_commit
  end
end