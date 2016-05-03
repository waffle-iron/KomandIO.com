require 'pathname'
require 'rugged'

class Git

  TOKEN = ENV['GITHUB_TOKEN']
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
    repo_clone_url = "http://github.com/#{repo_url}"
    Rugged::Repository.clone_at repo_clone_url, repo_path.to_s, credentials: git_credentials
  end

  def git_privatekey
    @git_privatekey ||= Rails.root + 'sshkeys/id_rsa'
  end

  def git_publickey 
    @git_publickey ||= Rails.root + 'sshkeys/id_rsa.pub'
  end
    
  def git_credentials
    @git_credentials ||= Rugged::Credentials::SshKey.new(privatekey: git_privatekey.to_s, publickey: git_publickey.to_s, passphrase: '')
  end

end
