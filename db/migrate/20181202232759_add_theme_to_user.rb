class AddThemeToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :theme, :string
  end
end
