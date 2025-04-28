FactoryBot.define do
  factory :blank_project, class: 'Project' do
    team
    title { "" }
    description { "" }
    visibility { 1 }
  end
end
