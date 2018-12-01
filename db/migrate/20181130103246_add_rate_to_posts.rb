class AddRateToPosts < ActiveRecord::Migration[5.2]
  def change
		add_column :posts, :aver_rate, :float, default: 0
  end
end
