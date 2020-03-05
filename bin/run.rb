require_relative '../config/environment'

def cli_runner
  prompt = TTY::Prompt.new
  user = start_screen(prompt)
end

User.create(user_name: "Kevin", password: "123456", balance: 0)

def start_screen(prompt)
  # Low priority- find out how to use multiple words in one option in TTY
  choice = prompt.select("Would you like to login or create a new account?", %w(Login Create))
  if choice == "Login"
    user_name_prompt = prompt.ask('Username:') 
    user = User.find_by(user_name: user_name_prompt) 
    while !user || user_name_prompt == ""
      puts "Username not found. Please try again."
      # Stretch goal- add in an option to allow them to go to the previous menu
      user_name_prompt = prompt.ask('Username:')
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
    while User.find_by(user_name: user_name_prompt)
      puts "Username is already taken."
      user_name_prompt = prompt.ask('What would you like your user name to be?')
    end
    password_prompt = prompt.mask('What would you like your password to be?')

    user = User.create(user_name: user_name_prompt, password: password_prompt)
    start_screen(prompt)
  end
end

def main_menu(prompt, user)
  choice = prompt.select("Please select an option.",%w(Library Store Wallet Logout))
  #if that username is already in our db, need to say invalid username and escape to main menu, then change below to elsif
  if choice == "Library"
    library(prompt, user)
  elsif choice == "Store"
    store(prompt, user)
  elsif choice == "Wallet"
    wallet(prompt, user)
  elsif choice == "Logout"
    start_screen(prompt)
  end
end

def library(prompt,user)
  # Stretch goal: User receives all games in a selectable list.
  # Selecting a game will return info for that game
  @collection = user.games
  #Stretch: want to be able to access the id of the selected game 
  #Actually prob doesn't matter 
  selected_game_title = prompt.select("Please select a game.", @collection.map{|game| game.title})
  selected_game = @collection.find_by(title: "#{selected_game_title}")
  puts selected_game.attributes.map{|k,v| "#{k} = #{v}"}.join("\n")
  main_menu(prompt, user)
end


def store

end

def wallet(prompt, user)
  @responses = ["Check Balance", "Add Funds", "Main Menu"]
  @fund_options = [10, 20, 50, 100, 200, 500, 1000]
  response = prompt.select("Please select an option:", @responses)
  #check wallet balance
  if response == "Main Menu"
    main_menu(prompt, user)
  elsif response == "Check Balance"
    puts user.balance 
    wallet(prompt, user)
  elsif response == "Add Funds"
    money_to_add = prompt.select("Select an amount to add to your wallet:", @fund_options)   
    user.balance += money_to_add
    wallet(prompt, user)
  end
end
cli_runner