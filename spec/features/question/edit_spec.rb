require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, author: user) }
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit the question' do
    visit question_path(question)

    expect(find('.question')).to_not have_link 'Edit'
  end

  scenario "Authenticated user can not edit other user's question" do
    sign_in(other_user)
    visit question_path(question)
  
    expect(find('.question')).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'tries to edit his question', js: true do
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        attach_file 'Files', ["#{Rails.root}/README.md", "#{Rails.root}/spec/spec_helper.rb"], multiple: true
        find('.octicon').click

        click_on 'Save'
      end

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.files
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'README.md'
      expect(find('.question')).to_not have_selector 'textarea'
    end

    scenario 'tries to edit his question with errors', js: true do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
