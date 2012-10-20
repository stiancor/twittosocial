namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.all.each do |a|
      a.delete
    end
    admin = User.create!(name: "Example user",
                         email: "example@example.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password = "foobar"
      password_confirmation = "foobar"
      User.create!(name: name, email: email, password: password, password_confirmation: password_confirmation)
    end
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end

end