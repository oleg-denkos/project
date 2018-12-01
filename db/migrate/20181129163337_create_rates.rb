class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.float :rating
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
