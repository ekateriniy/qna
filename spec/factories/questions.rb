FactoryBot.define do
  factory :question do
    author
    title { "MyString" }
    body { "MyText" }
    best_answer { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
    end

    # trait :with_link do
    #   links { create(:link, name: 'answer link', url: 'answer url') }
    # end
  end
end
