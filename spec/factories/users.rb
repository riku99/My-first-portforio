FactoryBot.define do
  factory :user do
    name { "riku" }
    email { "riku@example.com" }
    acount_id { "riku" }
    score { 1 }
    target_score { 1 }
    password { "foobar" }
    password_confirmation { "foobar" }

    trait :duplicate_acount_id_user do
      name { "riku2" }
      email { "riku2@example.com" }
      acount_id { "riku" }
      score { 2 }
      target_score { 2 }
      password { "foobar" }
      password_confirmation { "foobar" }
    end

      trait :name_nil do
        name { nil }
      end

      trait :email_nil do
        email { nil }
      end

      trait :name_over_word do
        name { "r" * 26 }
      end

      trait :email_over_word do
        email { "r" * 244 + "@example.com" }
      end
  end
end
