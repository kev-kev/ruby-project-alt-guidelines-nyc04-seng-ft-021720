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



end



