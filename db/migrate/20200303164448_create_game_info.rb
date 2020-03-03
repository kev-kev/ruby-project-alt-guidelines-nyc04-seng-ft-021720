class CreateGameInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :title
      t.string :genre
      t.string :platform
      t.integer :price
      t.string :release_date
      t.string :esrb_rating
      t.float :review_score 
    end
  end
end
