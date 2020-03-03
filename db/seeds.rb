#fake_name = Faker::Name.name
#fake_password = Faker::Alphanumeric.alpha(number: 10)

#Seed users
user1 = User.create(user_name:"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user2 = User.create(user_name:"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user3 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user4 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user5 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user6 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user7 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user8 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user9 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)
user10 = User.create(:user_name=>"#{Faker::Name.name}",:password =>"#{Faker::Alphanumeric.alpha(number: 10)}",balance: 0)

#Seed games
esrb_letters = ["E", "T", "M", "RP"]
game1 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game2 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game3 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game4 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game5 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game6 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game7 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game8 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game9 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))
game10 = Game.create(title:"#{Faker::Game.title}", genre: "#{Faker::Game.genre}", platform: "#{Faker::Game.platform}", price: (rand(20...70)).round_to(5), release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", esrb_rating: esrb_letters.sample, review_score: rand(0.0...10).to_f.round(2))

10.times{Purchase.create(:game => Game.all.shuffle.first, :user => User.all.shuffle.first)}
#{Purchase.create(:game => game1, :user => user1)}