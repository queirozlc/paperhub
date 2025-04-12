FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
  end

  factory :user_verified, parent: :user do
    name { "John Doe" }

    after (:create) do |user|
      user.new_personal_team(user.name)
    end
  end
end
