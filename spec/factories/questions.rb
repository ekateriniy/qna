FactoryBot.define do
  factory :question do
    author
    title { "MyString" }
    body { "MyText" }
    best_answer { nil }

    trait :invalid do
      title { nil }
    end
  end
end
