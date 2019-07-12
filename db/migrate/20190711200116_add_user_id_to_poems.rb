class AddUserIdToPoems < ActiveRecord::Migration[5.2]
  def change
    add_column :poems, :user_id, :integer
  end
end
