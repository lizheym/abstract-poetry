class AddOriginalToPoems < ActiveRecord::Migration[5.2]
  def change
    add_column :poems, :original, :string
  end
end
