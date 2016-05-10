require 'test_helper'

class RebasesControllerTest < ActionDispatch::IntegrationTest
  
  setup do 
    @repo_name = 'netoff/ruby-rails-sample'
    @pr = 1
  end

  teardown do 

  end

  def test_it_creates_new_rebase
    assert_difference 'Rebase.count' do 
      post rebases_path, params: {repo_url: @repo_name, pull_request_id: @pr}
    end
  end
end
