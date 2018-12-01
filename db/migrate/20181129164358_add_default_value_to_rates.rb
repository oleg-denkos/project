class AddDefaultValueToRates < ActiveRecord::Migration[5.2]
	def change
		change_column :rates, :rating, :float, default: 0.0
		add_column :rates, :voters_count, :integer, default: 0
	end
end
