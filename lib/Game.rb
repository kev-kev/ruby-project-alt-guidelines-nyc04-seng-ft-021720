class Game < ActiveRecord::Base

    has_many :purchases
    has_many :users, through: :purchases

    def self.get_game_by_id(given_id)
        # self.find_by_id(game_id: "#{given_id}") <- Incorrect
        # The attribute name is not game_id, it's just id.
        # It expects an integer and not a string. (See schema.rb)
        # self.find_by_id(id: given_id) <- Correct
        # Game.all.select{|game| game.id == game_id}.reduce <- ???
        self.find(given_id) 
        # ^ Don't need find_by_id if it's just the id, you can use find
    end

end