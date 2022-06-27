FactoryBot.define do
  factory :link do

    trait :for_question do
      name { 'question link body' }
      url { 'question link url' }
      association :linkable, factory: :question
    end

    trait :for_answer do
      name { 'answer link body' }
      url { 'answer link url' }
      association :linkable, factory: :answer
    end
  end
end
