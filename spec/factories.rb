FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@example.com" }
    sequence(:username) { |n| "Username_#{n}"}
    password 'foobar'
    password_confirmation 'foobar'

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content 'Lorem ipsum'
    user
  end

  factory :event do
    title 'My first event'
    start_time DateTime.new.at_beginning_of_hour
    end_time DateTime.new.at_midnight
    invitation 'This is an invitation'
    user
  end

  factory :event_invite do
    attend_status 0
    event
    user
  end
end

