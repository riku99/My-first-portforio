FactoryBot.define do
  factory :favorite do
    association :user
    association :discovery
    association :comment
  end
end
