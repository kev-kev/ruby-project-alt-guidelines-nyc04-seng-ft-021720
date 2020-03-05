require_relative '../config/environment'

puts "hello world"

def cli_runner
  prompt = TTY::Prompt.new
  user = start_screen(prompt)
  main_menu(prompt, user)
end

kevin = User.create(user_name: "Kevin", password: "123456", balance: 1000)
fakerrpg = Game.create(title:"FakerJRPG", genre: "JRPG", platform: "#{Faker::Game.platform}", price: 30, release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: "E", review_score: 10)
Purchase.create(:game => fakerrpg, :user => kevin)
    def start_screen(prompt)
        # Low priority- find out how to use multiple words in one option in TTY
        choice = prompt.select("Would you like to login or create a new account?", %w(Login Create))
        if choice == "Login"
          user_name_prompt = prompt.ask('Username:') 
          password_prompt = prompt.mask('Password:')
          user = User.find_by(user_name: user_name_prompt)
          unless user
            puts "Username not found. Please try again."
            # Stretch goal- add in an option to allow them to go to the previous menu
            start_screen(prompt)
          end
          return user
          # Checks if the inputted password is equal to the password on file.
          while user.password != password_prompt.to_s
            puts "Incorrect password. Please try again."
            password_prompt = prompt.mask('Password:')
          end
          return user
        else
          # Create new user account
          user_name_prompt = prompt.ask('What would you like your user name to be?')
          password_prompt = prompt.mask('What would you like your password to be?')
          user = User.create(user_name: user_name_prompt, password: password_prompt)
        end
        return user
      end


  def main_menu(prompt, user)
    
    choice = prompt.select("Please select an option.",%w(Library Store Wallet))
    if choice == "Library"
      library(prompt, user)
    elsif choice == "Store"
      store(prompt,user)
    elsif choice == "Wallet"
      wallet(prompt,user)
    end
  end

def store(prompt, user)
    first_option = prompt.select("Welcome to our fake store! What would you like to do",%w(Browse AddFunds))
    if first_option == "AddFunds"
        amount_added = prompt.ask("How much do you want to add?")
            user.balance += amount_added.to_i
            puts "Your new balance is #{user.balance}"
        end

#   stretch add best selling as sorting option
    
    
    choice = prompt.select("How would you like to sort our options",%w(Genre Rating Price))

    case choice
    when "Genre"
        genre_choice = prompt.ask("Which Genre are you looking for")
        games_by_genre_instances = Game.all.where(genre: genre_choice)
        @games_by_genre = games_by_genre_instances.map {|x| x.title}
        chosen_game = prompt.select("Which game would you like to view",@games_by_genre)
        chosen_game_instance = Game.all.find_by(title: chosen_game)
        chosen_game_id = chosen_game_instance.id
        
        is_buying = prompt.yes?("Would you like to purchase this game")
        if is_buying == true
            user.make_purchase(chosen_game_id) 
            puts "Returning to Store menu"
            main_menu(prompt,user)
        else
         puts "You selected no , Returning to the Store menu"
         store(prompt,user)
        end

when "Rating"
    puts "Sorting by rating"
    games_by_rating = Game.all.order(:rating)
    @games_by_rating = game_by_rating.map {|x| x.title}
    chosen_game = prompt.select("Which game would you like to view",(@games_by_rating))
    chosen_game_id = Game.all.where(chosen_game).id
    is_buying = prompt.yes?("Would you like to purchase this game")
    if is_buying == "Y"
        if user.make_purchase(chosen_game_id) == "Insufficient Funds"
          puts "Insufficient Funds, please return to the menu and add funds"
          main_menu(prompt,user)
        end
    else
        puts "Returning to the Store menu"
        store(prompt,user)
    end
end
end
cli_runner






