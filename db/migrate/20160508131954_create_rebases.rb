class CreateRebases < ActiveRecord::Migration[5.0]
  def change
    create_table :rebases do |t|

      t.timestamps
    end
  end
end
