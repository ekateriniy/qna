require 'rails_helper'

feature 'User can comment a question', %q{
  In order to express some thoughts
  As an authenticated user
  I'd like to be able to comment a question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'comments the question' do
      within '.question-new-comment' do
        fill_in 'comment_body', with: 'Comment body'
        click_on 'Post comment'
      end

      expect(page).to have_content 'Comment body'
    end

    scenario 'comments the question with errors' do
      within '.question-new-comment' do
        click_on 'Post comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'multiple sessions', js: true do
    scenario "question's comment appears on other user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-new-comment' do
          fill_in 'comment_body', with: 'Comment body'
          click_on 'Post comment'
        end
        
        expect(page).to have_content 'Comment body'
      end

      Capybara.using_session('other user') do
        expect(page).to have_content 'Comment body'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the question' do
    visit question_path(question)

    expect(page).to_not have_css('.question-new-comment')
  end
end
