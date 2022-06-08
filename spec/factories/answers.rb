FactoryBot.define do
  factory :answer do
    association :question

    title { "AnswerTitle" }
    body { "AnswerBody" }

    trait :invalid do
      title { nil }
    end
  end
end
