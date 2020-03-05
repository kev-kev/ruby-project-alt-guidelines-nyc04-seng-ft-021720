require_relative '../config/environment'

def cli_runner
  prompt = TTY::Prompt.new
  user = start_screen(prompt)
end

def start_screen(prompt)
  choice = prompt.select("Would you like to login or create a new account?", %w(Login Create\ Account))
  if choice == "Login"
    user_name_prompt = prompt.ask('Username:') 
    user = User.find_by(user_name: user_name_prompt)
    while !user || user_name_prompt == nil
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
  @collection = user.games
  if @collection == []
    puts "You don't currently own any games."
    main_menu(prompt, user)
  end
  selected_game_title = prompt.select("Please select an option", @collection.map{|game| game.title})
  selected_game = @collection.find_by(title: "#{selected_game_title}")
  puts selected_game.attributes.map{|k,v| "#{k} = #{v}"}.join("\n")
  main_menu(prompt, user)
end

def store(prompt, user)
#  Stretch add best selling as sorting option
  choice = prompt.select("How would you like to sort the games?",%w(Genre Review\ Score Price Main\ Menu)) #Add in Refund\ Game to arr if we want to implement refunds
    case choice
    when "Main Menu"
      main_menu(prompt, user)

    when "Genre"
      genre_choice = prompt.select("Which Genre are you looking for?", %w(RPG JRPG Strategy FPS Action MOBA Indie MMO Sports Simulation))
      games_by_genre_instances = Game.all.where(genre: genre_choice)
      @games_by_genre = games_by_genre_instances.map {|x| x.title}
      chosen_game = prompt.select("Which game would you like to view?",@games_by_genre)
      chosen_game_instance = Game.all.find_by(title: chosen_game)
      chosen_game_id = Game.find_by(title: chosen_game).id
      puts chosen_game_instance.attributes.map{|k,v| "#{k} = #{v}"}.join("\n")
      is_buying = prompt.yes?("Would you like to purchase this game? $#{chosen_game_instance.price} will be removed from your wallet balance.\nCURRENT WALLET BALANCE: $#{user.balance}")
      if is_buying
        if user.make_purchase_by_id(chosen_game_id) == "Insufficient Funds."
          puts "Insufficient Funds, please add funds to your wallet and try again. \nReturning to the Main Menu"
          main_menu(prompt,user)
        else
          puts "Returning to the Store Menu."
          store(prompt, user)
        end
      else
        puts "Returning to the Store Menu."
        store(prompt, user)
      end

    when "Review Score"
      puts "Sorting by review score"
      @games_by_rating = Game.all.order("review_score DESC")
      game_titles = @games_by_rating.map{|game| game.title}
      chosen_game = prompt.select("Which game would you like to view", game_titles)
      chosen_game_id = Game.find_by(title: chosen_game).id
      chosen_game_instance = Game.all.find_by(title: chosen_game)
      puts chosen_game_instance.attributes.map{|k,v| "#{k} = #{v}"}.join("\n")
      is_buying = prompt.yes?("Would you like to purchase this game? $#{chosen_game_instance.price} will be removed from your wallet balance.\nCURRENT WALLET BALANCE: $#{user.balance}")
      if is_buying
        if user.make_purchase_by_id(chosen_game_id) == "Insufficient Funds."
          puts "Insufficient Funds, please add funds to your wallet and try again. \nReturning to the Main Menu"
          main_menu(prompt,user)
        else
          puts "Returning to the Store menu"
          store(prompt, user)
        end
      else
        puts "Returning to the Store Menu."
        store(prompt, user)
      end
    
    when "Price"
      puts "Sorting by Price"
      @games_by_price = Game.all.order("price")
      game_titles = @games_by_price.map{|game| game.title}
      chosen_game = prompt.select("Which game would you like to view", game_titles)
      chosen_game_id = Game.find_by(title: chosen_game).id
      chosen_game_instance = Game.all.find_by(title: chosen_game)
      puts chosen_game_instance.attributes.map{|k,v| "#{k} = #{v}"}.join("\n")
      is_buying = prompt.yes?("Would you like to purchase this game? $#{chosen_game_instance.price} will be removed from your wallet balance.\nCURRENT WALLET BALANCE: $#{user.balance}")
      if is_buying
        if user.make_purchase_by_id(chosen_game_id) == "Insufficient Funds."
          puts "Insufficient Funds, please add funds to your wallet and try again. \nReturning to the Main Menu"
          main_menu(prompt,user)
        else
          puts "Returning to the Store menu"
          store(prompt, user)
        end
      else
        puts "Returning to the Store Menu."
        store(prompt, user)
      end

    # Taking out game refund 
    # when "Refund Game"
    #   # binding.pry
    #   game_to_refund = prompt.select("Please select a game to refund.", user.games.map{|game| game.title })
    #   # add the price of the game to the users balance
    #   money_to_refund = user.games.find_by(title: game_to_refund).price #instead use user.purchases.find_by(title: game_to_refund).price
    #   purchase_id_to_refund = user.purchases.find_by(title: game_to_refund).id
    #   binding.pry
      
    #   purchases.destroy(purchase_id_to_refund)
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