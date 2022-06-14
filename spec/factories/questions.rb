FactoryBot.define do
  factory :question do
    author
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
