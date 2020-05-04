FactoryBot.define do
  factory :user do
    name { "riku" }
    email { "riku@example.com" }
    acount_id { "riku" }
    score { 770 }
    target_score { 900 }
    password { "foobar" }
    password_confirmation { "foobar" }
    introduce { "hello" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/images/test.jpg')) }
    remember_digest {nil}

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
