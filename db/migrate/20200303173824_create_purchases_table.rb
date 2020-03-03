class CreatePurchasesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.integer :game_id
      t.integer :user_id
    end
  end
end
