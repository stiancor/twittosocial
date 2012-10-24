namespace :db do
  desc "make everybody follow everybody else"
  task follow_everybody: :environment do
    users = User.all
    users.each do |user|
      users.each do |other_user|
        if user.id != other_user.id
          if !Relationship.find_by_follower_id_and_followed_id(user.id, other_user.id)
            relationship = Relationship.new(followed_id: other_user.id)
            relationship.follower_id = user.id
            relationship.save
            puts "#{relationship.follower_id} #{relationship.followed_id}"
          end
        end
      end
    end
  end
end
