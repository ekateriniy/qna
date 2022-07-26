FactoryBot.define do
  factory :user, aliases: [:author] do
    sequence(:email) { |n| "user#{n}@test.com" }
    password { '1234567890' }
    password_confirmation { '1234567890' }

    before(:create) {|user| user.skip_confirmation! }
  end
end
