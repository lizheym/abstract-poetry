class AddPublicToPoems < ActiveRecord::Migration[5.2]
  def change
    add_column :poems, :public, :boolean, :default => false
  end
end
