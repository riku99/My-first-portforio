FactoryBot.define do
  factory :discovery do
      content { "RSpec sample" }
      association :user
    end
  end
