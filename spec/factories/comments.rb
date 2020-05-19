FactoryBot.define do
  factory :comment do
    content { "sample comment" }
    association :discovery
    user { discovery.user }
  end
end
