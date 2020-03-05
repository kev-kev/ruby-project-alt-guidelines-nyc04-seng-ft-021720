class User < ActiveRecord::Base
  
  has_many :purchases
  has_many :games, through: :purchases

  def view_owned_game_ids  # takes the users's purchase instances and returns the game ids
    self.games.map do |game|
      games.id
    end
  end

  def users_games_instances_by_id # takes the user's game ids and returns the info for each
    self.view_owned_game_ids.map do |x| # an array of game ids that the user owns
      Game.all.select do | game|         #checks all games that equal the users's game id 
      game.id == x               #and returns them as an array of game instances
      end
    end
  end

  #take the above game instances and return their info in an array
  def game_info_by_instances
    self.users_games_instances_by_id.flatten.map{ |game|
      [game.title, game.genre, game.platform, game.price, game.release_date, game.esrb_rating, game.review_score]
    }
  end

  #take in a selected game id that we wanna purchase, add the game to the library, deduct the game price from balance
  def make_purchase_by_id(selected_game_id) 
    game = Game.find_by(id: selected_game_id)
    if self.balance - game.price >= 0
      Purchase.create(:game => game, :user => self)# :price => game.price
      self.balance -= game.price
      puts "Purchase Complete!" #1
      puts "Your balance is now #{self.balance}."
    else
      return "Insufficient Funds."#2
    end
  end

  def refund_purchase_by_id(selected_game_id)

  end
end