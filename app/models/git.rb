require 'pathname'

class Git #< ApplicationRecord

  TOKEN = "26f6585e7c821db223c4a29d8c28b8d24fe88e2f"
  TEST_REPO = 'netoff/ruby-rails-sample'

  attr_reader :client, :home_path
  
  def initialize
    @client = Octokit::Client.new(access_token: TOKEN)
    @home_path = Pathname.new('~').expand_path
  end

  def create_github_repo repo_url
    repo_url.strip!
    repo_url.slice!(0) if repo_url.start_with?("/")
   
    repo = nil
    GitRepo.transaction do 
      repo = GitRepo.create repo_url: repo_url, repo_type: 'github'
      clone_github_repo repo_url, repo.repo_path
      repo
    end

    repo
  end

  def git_working_tree? path
    cmd = "cd #{path} && git rev-parse --is-inside-work-tree"
    res = system cmd 
    res.to_s.downcase == "true"
  end

  private

  def clone_github_repo repo_url, repo_path
    repo_clone_url = "git@github.com:#{repo_url}.git"
    cmd = "git clone #{repo_clone_url} #{repo_path}"
    system cmd
  end

end
