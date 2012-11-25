namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    delete_users
    make_users
    make_microposts
    make_relationships
  end
end

def delete_users
  User.all.each do |a|
    a.delete
  end
end

def make_users
  admin = User.create!(name: "Example user",
                       email: "example@example.com",
                       username: "admin",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    username = "username-#{n+1}"
    password = "foobar"
    password_confirmation = "foobar"
    User.create!(name: name, email: email, username: username, password: password, password_confirmation: password_confirmation)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

