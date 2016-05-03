class CreateGitRepos < ActiveRecord::Migration[5.0]
  def change
    create_table :git_repos do |t|
      t.string :repo_url
      t.string :repo_type

      t.timestamps
    end
  end
end
