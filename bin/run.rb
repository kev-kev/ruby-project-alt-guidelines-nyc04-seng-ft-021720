require_relative '../config/environment'

puts "hello world"

def cli_runner
  prompt = TTY::Prompt.new
  start_screen(prompt)
  main_menu(prompt)
end

User.create(user_name: "Kevin", password: "123456", balance: 0)

def start_screen(prompt)
  # Low priority- find out how to use multiple words in one option in TTY
  choice = prompt.select("Would you like to login or create a new account?", %w(Login Create))
  if choice == "Login"
    user_name_prompt = prompt.ask('Username:') 
    password_prompt = prompt.ask('Password:')
    user = User.find_by(user_name: user_name_prompt)
    # binding.pry
    unless user
      puts "Username not found. Please try again."
      # Stretch goal- add in an option to allow them to go to the previous menu
      start_screen(prompt)
    end
    # Checks if the inputted password is equal to the password on file.
    while user.password != password_prompt.to_s
      puts "Incorrect password. Please try again."
      # new ask for user password here
      password_prompt = prompt.ask('Password:')
    # else
      # Go to main menu 
    end
  else
    # Create new user account
    user_name_prompt = prompt.ask('What would you like your user name to be?')
    password_prompt = prompt.ask('What would you like your password to be?')
    new_user = User.create(user_name: user_name_prompt, password: password_prompt)
  end
end

def main_menu(prompt)
  choice = prompt.select("Please select an option.",%w(Library Store Wallet))
  if choice == "Library"
end

cli_runner