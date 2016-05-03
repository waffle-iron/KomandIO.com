class RemoveGits < ActiveRecord::Migration[5.0]
  def change
    drop_table :gits
  end
end
