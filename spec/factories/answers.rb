FactoryBot.define do
  factory :answer do
    association :question
    body { "AnswerBody" }

    trait :invalid do
      body { nil }
    end
  end
end
