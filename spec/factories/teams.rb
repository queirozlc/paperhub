FactoryBot.define do
  factory :team do
    owner { association :user, name: "John Doe" }
    name { owner.name }

    after(:create) do |team|
      team.owner.active_team = team
      team.owner.save
    end
  end
end
