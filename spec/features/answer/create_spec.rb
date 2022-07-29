require 'rails_helper'

feature 'User can create answer', %q{
  In order to help with someone's question
  As an authenticated user
  I'd like to be able to write an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer the question', js: true do
      fill_in 'answer_body', with: 'Answer body'
      click_on 'Post answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Answer body'
    end

    scenario 'answer the question with attached file', js: true do
      fill_in 'answer_body', with: 'Answer body'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], multiple: true

      click_on 'Post answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answer the question with errors', js: true do
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'multiple sessions', js: true do
    scenario "answer appears on other user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer_body', with: 'Answer body'
        click_on 'Post answer'

        expect(page).to have_content 'Answer body'
      end

      Capybara.using_session('other user') do
        expect(page).to have_content 'Answer body'
      end
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    
    expect(page).to_not have_content 'Post answer'
  end
end
