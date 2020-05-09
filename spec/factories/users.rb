FactoryBot.define do
  factory :user do
    name { "riku" }
    sequence(:email) { |n| "riku#{n}@example.com" }
    sequence(:acount_id) { |n| "riku#{n}" }
    score { 770 }
    target_score { 900 }
    password { "foobar" }
    password_confirmation { "foobar" }
    introduce { "hello" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/images/test.jpg')) }
    remember_digest {nil}
    admin { true }

    trait :second_user do
      name { "riku" }
      email { "rikusecond@example.com" }
      acount_id { "secondriku" }
      score { 770 }
      target_score { 900 }
      password { "foobar" }
      password_confirmation { "foobar" }
      introduce { "hello2" }
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/images/test.jpg')) }
      remember_digest {nil}
      admin { nil }
    end

    trait :duplicate_acount_id_user do
      name { "riku2" }
      email { "riku2@example.com" }
      acount_id { "wow" }
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
