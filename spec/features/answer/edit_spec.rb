require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_file, question: question, author: user) }
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "Authenticated user tries to edit other user's answer" do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end


  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      find('.edit-answer-link').click
      within '.answers' do
        fill_in 'answer_body', with: 'edited answer'
        attach_file 'Files', ["#{Rails.root}/README.md", "#{Rails.root}/spec/spec_helper.rb"], multiple: true

        find('.octicon').click
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_content answer.files
        expect(page).to have_link 'README.md'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors' do
      find('.edit-answer-link').click
      within '.answers' do
        fill_in 'answer_body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
