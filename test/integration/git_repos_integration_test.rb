require 'test_helper'

class GitReposIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @repo_name = 'netoff/ruby-rails-sample'
    @branch_name = 'test-branch'
  end

  teardown do
    GitRepo.all.each do |repo|
      repo.destroy
    end 
  end

  def test_it_can_display_repo_its_branches_and_pull_requests
    visit root_path

    within "[data-repo='#{@repo_name}']" do
      click_on "View"
    end    

    assert_text @repo_name

    within "#branches" do 
      assert_text "test-branch"
    end

    within "#pull_requests" do 
      assert_text "Test PR"
    end
  end

  def test_it_displays_pull_request
    visit root_path

    #open 'ruby-rails-sample' path
    within "[data-repo='#{@repo_name}']" do
      click_on "View"
    end   

    within "#pull_requests" do 
      click_on "Test PR"
    end

    assert_current_path git_repo_pull_request_path(git_repo_id: @repo_name, id: '1')
    assert_text 'Test PR'

    within "#commits" do 
      assert_text "test 1"
      assert_text "test 2"
    end

    within "#files" do 
      assert_text "test.txt"
    end
  end

  def test_it_deletes_commit
    visit git_repo_pull_request_path(git_repo_id: @repo_name, id: '1')

    within "#commits li:nth-child(2)" do 
      find('label', text: "Delete").click 
    end

    click_on "Rebase"

    visit git_repo_pull_request_path(git_repo_id: @repo_name, id: '1')

    within "#commits" do 
      assert_text "test 1"
      assert_no_text "test 2"
    end

    # save_and_open_page
    save_and_open_screenshot


    # clean rebase algorithm:
    # - given the repo_url give me the local copy of repo(together with clone)
    #   if it already exists do nothing, just return it 
    # - get local repo path
    # - git fetch and git checkout given branch 
    # - create new rebase object 
    # - compile 'rebase' text instruction, to be saved with rebase object
    # - inside local copy invokie interactive rebase:
    #     - pipe rails command as rebase editor, together with rebase id
    # - 1) if everything clean, push force to remote origin
    # - 2) if not clean go to rebase editor to fix issues, and continue rebase  
    # rebase with conflicts algorithm 
    # - go to rebase conflicts editor
    # - display list of all conflict files
    # - save files, and 'rebase --continue'
    # - unless done repeat edit process
    # - if done go to commit editor
    # - get commit message, and save
    # - push force to remote 
  end

  def test_it_squashes_commits
    
  end
end