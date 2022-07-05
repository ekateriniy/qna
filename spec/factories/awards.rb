FactoryBot.define do
  factory :award do
    question
    user
    title { "MyAward" }
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/images/kopi_tabao.jpg") }

    trait :invalid do
      title { nil }
    end
  end
end
