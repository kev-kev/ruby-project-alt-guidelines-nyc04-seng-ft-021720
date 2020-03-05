require_relative '../config/environment'

def cli_runner
  prompt = TTY::Prompt.new
  user = start_screen(prompt)
end

kevin = User.create(user_name: "Kevin", password: "123456", balance: 1000)
fakerrpg = Game.create(title:"FakerJRPG", genre: "JRPG", platform: "#{Faker::Game.platform}", price: 30, release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: "E", review_score: 10)
Purchase.create(:game => fakerrpg, :user => kevin)

def start_screen(prompt)
  # Low priority- find out how to use multiple words in one option in TTY
  choice = prompt.select("Would you like to login or create a new account?", %w(Login Create))
  if choice == "Login"
    user_name_prompt = prompt.ask('Username:') 
    user = User.find_by(user_name: user_name_prompt) 
    while !user || user_name_prompt == ""
      user_answer = prompt.yes?("Username not found. Return to previous menu?")
      if user_answer == true
        start_screen(prompt)
      else
      # Stretch goal- add in an option to allow them to go to the previous menu
      user_name_prompt = prompt.ask('Username:')
      end
    end
    password_prompt = prompt.mask('Password:')
    # # Checks if the inputted password is equal to the password on file.
    while user.password != password_prompt.to_s
      puts "Incorrect password. Please try again."
      password_prompt = prompt.mask('Password:')
    end
    main_menu(prompt, user)
  else
    # Create new user account
    user_name_prompt = prompt.ask('What would you like your user name to be?')
    while user_name_prompt == nil || user_name_prompt.to_s.length > 16
      puts "Invalid username"
      user_name_prompt = prompt.ask('What would you like your user name to be?')
    end
    while User.find_by(user_name: user_name_prompt)
      puts "Username is already taken."
      user_name_prompt = prompt.ask('What would you like your user name to be?')
    end
    password_prompt = prompt.mask('What would you like your password to be?')

    user = User.create(user_name: user_name_prompt, password: password_prompt, balance: 0)
    start_screen(prompt)
  end
end

def main_menu(prompt, user)
  choice = prompt.select("Please select an option.",%w(Library Store Wallet Logout Delete\ Account))
  #if that username is already in our db, need to say invalid username and escape to main menu, then change below to elsif
  if choice == "Library"
    library(prompt, user)
  elsif choice == "Store"
    store(prompt, user)
  elsif choice == "Wallet"
    wallet(prompt, user)
  elsif choice == "Logout"
    start_screen(prompt)
  elsif choice == "Delete Account"
    delete_account(prompt, user)
  end
end

def library(prompt, user)
  # Stretch goal: User receives all games in a selectable list.
  # Selecting a game will return info for that game
  @collection = user.games
  if @collection == []
    puts "You don't currently own any games."
    main_menu(prompt, user)
  end
  #Stretch: want to be able to access the id of the selected game 
  #Actually prob doesn't matter 
  selected_game_title = prompt.select("Please select a game.", @collection.map{|game| game.title})
  selected_game = @collection.find_by(title: "#{selected_game_title}")
  puts selected_game.attributes.map{|k,v| "#{k} = #{v}"}.join("\n")
  main_menu(prompt, user)
end

def store(prompt, user)
#  Stretch add best selling as sorting option
  choice = prompt.select("How would you like to sort our options",%w(Genre Rating Price))
  case choice
    when "Genre"
      genre_choice = prompt.ask("Which Genre are you looking for")
      games_by_genre_instances = Game.all.where(genre: genre_choice)
      @games_by_genre = games_by_genre_instances.map {|x| x.title}
      chosen_game = prompt.select("Which game would you like to view", @games_by_genre)
      chosen_game_instance = Game.all.find_by(title: chosen_game)
      chosen_game_id = chosen_game_instance.id
      is_buying = prompt.yes?("Would you like to purchase this game")

      if is_buying == true
        user.make_purchase_by_id(chosen_game_id) 
        puts "Returning to Store menu"
        main_menu(prompt,user)
      else
        puts "You selected no , Returning to the Store menu"
        store(prompt,user)
      end

  when "Rating"
    puts "Sorting by rating"
    @games_by_rating = Game.all.order(:rating).map {|x| x.title}
    chosen_game = prompt.select("Which game would you like to view",(@games_by_rating))
    chosen_game_id = Game.all.where(chosen_game).ids
    is_buying = prompt.yes?("Would you like to purchase this game")
    if is_buying == "Y"
        if user.make_purchase_by_id(chosen_game_id) == "Insufficient Funds"
          puts "Insufficient Funds, please return to the menu and add funds"
          main_menu(prompt,user)
        end
    else
        puts "Returning to the Store menu"
        store(prompt,user)
    end
  end
end

def wallet(prompt, user)
  @responses = ["Check Balance", "Add Funds", "Main Menu"]
  @fund_options = [10, 20, 50, 100, 200, 500, 1000]
  response = prompt.select("Please select an option:", @responses)
  if response == "Main Menu"
    main_menu(prompt, user)
  elsif response == "Check Balance"
    puts user.balance 
    wallet(prompt, user)
  elsif response == "Add Funds"
    money_to_add = prompt.select("Select an amount to add to your wallet:", @fund_options)   
    user.balance += money_to_add
    user.save
    wallet(prompt, user)
  end
end

def delete_account(prompt, user)
  response1 = prompt.select("Delete your account?", %w(Yes No))
  if response1 == "No"
    main_menu(prompt, user)
  else
    response2 = prompt.select("Are you sure you'd like to delete your account? You will lose any remaining balance in your wallet and any games in your library.", %w(Yes No))
    if response2 == "No"
      main_menu(prompt, user)
    else
      User.destroy(user.id)
      start_screen(prompt)
    end
  end
end
cli_runner