FactoryBot.define do
  factory :answer do
    author
    question
    body { "AnswerBody" }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
    end
  end
end
