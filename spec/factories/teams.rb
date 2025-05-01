FactoryBot.define do
  factory :team do
    owner { association :user, name: "John Doe" }
    sequence(:name) { |n| "Team #{n}" }

    after(:create) do |team|
      team.owner.memberships.create!(
        team: team,
        role: :owner,
      )
    end
  end

  factory :personal_team, class: "Team" do
    owner { association :user, name: "John Doe" }
    name { owner.name }

    after(:create) do |team|
      team.owner.memberships.create!(
        team: team,
        role: :owner,
      )
      team.owner.set_current_team(team)
    end
  end
end
