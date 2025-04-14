FactoryBot.define do
  factory :project do
    team { nil }
    name { "MyString" }
    description { "MyString" }
    visibility { 1 }
  end
end
