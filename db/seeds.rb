50.times{
  User.create(
    user_name: "#{Faker::Name.name}",
    password: "#{Faker::Alphanumeric.alpha(number: 10)}",
    balance: 0)
  }

#Seed games
esrb_letters = %w[E T M RP]
genre_arr = %w[RPG JRPG Strategy FPS Action MOBA Indie MMO Sports Simulation]
100.times{
  Game.create(
    title:"#{Faker::Game.title}", 
    genre: genre_arr.sample, 
    platform: "#{Faker::Game.platform}", 
    price: (rand(20...70)).round_to(5), 
    release_date: "#{Faker::Date.between(from: 10.years.ago, to: Date.today)}", 
    esrb_rating: esrb_letters.sample, 
    review_score: rand(0.0...10).to_f.round(2), 
    description: Faker::Marketing.buzzwords)
  }

50.times{
  Purchase.create(
    game: Game.all.shuffle.first,
    user: User.all.shuffle.first)
}