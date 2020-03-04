require_relative '../config/environment'

puts "hello world"

def cli_runner
prompt = TTY::Prompt.new
start_screen(prompt)
create_user(prompt)



end

def start_screen
    choice = prompt.select("Would you like to login or create a new account?", %w("Login" "Create a new account"))
    if choice == "Login"
        user_name_prompt = prompt.ask('What is your user name?') 
         unless User.find_by(user_name: user_name_prompt )
            puts "Username not found"
           choice = prompt.select("Would you like to try again", %w("try Logging in again" "Create a new account"))
            if choice == "Create a new account"
             user_name_prompt = prompt.ask('What would you like your user name to be?')
             new_user = User.create(user_name: user_name_prompt)
             password_prompt = prompt.ask('What would you like your password to be?')
             new_user.password = password_prompt
             new_user.save
            end
         else
        user_password_prompt = prompt.ask('What is your password?')
    end
         
        


def create_user(prompt)
    name = prompt.ask('What is your name?') 
   if User.login_or_new_user(name).user_name == name
    password = prom

end


def menu(prompt,)


    

end

prompt.ask('What is your name?', default: ENV['USER'])
prompt.yes?('Do you like Ruby?')