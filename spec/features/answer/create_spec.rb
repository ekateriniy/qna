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

    scenario 'answer the question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Post answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Your answer successfully posted'
      expect(page).to have_content 'Answer body'
    end

    scenario 'answer the question with errors' do
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    click_on 'Post answer'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end