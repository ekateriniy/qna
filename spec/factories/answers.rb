FactoryBot.define do
  factory :answer do
    author
    question
    body { "AnswerBody" }

    trait :invalid do
      body { nil }
    end
  end
end
