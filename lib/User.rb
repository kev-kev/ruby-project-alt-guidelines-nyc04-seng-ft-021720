class User < ActiveRecord::Base
has_many :purchase
has_many :game, through: :purchase

#attr_accessor :user_name,:password,:balance


#def create(user_attributes)
 #   user_attributes.each {|key,value| self.send(("#{key}="))}
   # @name = name
  #  @password = password
 #   @balance = 0
#end

def login_or_new_user(users_name)
self.find_or_create_by_user_name(user_name: "#{users_name}")
end

def view_purchase_instances # returns the user's purchases instances
Purchase.all.select do |purchase|
  purchase.user_id == self.id
end
end

def view_owned_game_ids  # takes the users's purchase instances and returns the game ids
  self.view_purchase_instances.map do | purchase|
    purchase.game_id
  end
end

def users_games_instances_by_id # takes the user's game ids and returns the info for each
  self.view_owned_game_ids.map do |x| # an array of game ids that the user owns
    Game.all.select do | game|         #checks all games that equal the users's game id 
     game.id == x               #and returns them as an array of game instances
    end
  end
end

def





end
