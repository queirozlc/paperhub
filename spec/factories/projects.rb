FactoryBot.define do
  factory :blank_project do
    team { association :team }
    title { "" }
    description { "" }
    visibility { 1 }
  end
end
