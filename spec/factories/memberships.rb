FactoryBot.define do
  factory :membership do
    team { association :team }
    member { association :user_verified }
    role { :member }
  end
end
