class 001UserInfo < ActiveRecord::Migration[5.2]





  def change

    create_table :users do |t|
      t.string :user_name
      t.string :password
      t.array :library
      t.integer :balance

    end
      



  end





end
