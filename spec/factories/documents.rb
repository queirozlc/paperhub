FactoryBot.define do
  factory :blank_document, class: 'Document' do
    team { association :personal_team }
    title { "" }
    description { "" }
    visibility { 1 }
  end
end
