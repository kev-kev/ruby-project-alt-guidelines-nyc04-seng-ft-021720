class User < ActiveRecord::Base
has_many :purchase
has_many :game, through: :purchase

attr_accessor :user_name,:password,:balance,:library,


def initialize(user_attributes)
    user_attributes.each {|key,value| self.send(("#{key}="))}
    @library = []
    @balance = 0
end



end



