class Game < ActiveRecord::Base

    has_many :purchases
    has_many :user, through: :purchases
    
end