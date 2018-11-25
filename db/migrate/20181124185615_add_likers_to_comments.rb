class AddLikersToComments < ActiveRecord::Migration[5.2]
  def change
  	add_column :comments, :likers_count, :integer, :default => 0
  end
end
