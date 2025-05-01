FactoryBot.define do
  factory :blank_project, class: 'Project' do
    team { association :personal_team }
    title { "" }
    description { "" }
    visibility { 1 }
  end
end
