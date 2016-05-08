require 'pathname'
require 'rugged'

class Git
  TOKEN = ENV['GITHUB_TOKEN']
  
  attr_reader :github, :home_path
  
  def initialize
    raise "GitHub token not present" unless TOKEN.present?
    @github = Octokit::Client.new(access_token: TOKEN)
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
    return true if Rugged::Repository.new path
  rescue
    false
  end

  def repo_path repo_url
    home_path + repo_url
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
