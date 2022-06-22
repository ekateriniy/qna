require 'rails_helper'

feature 'User can delete written answer', %q{
  In order to delete written answer
  As an authenticated user
  I'd like to be able to delete answer, written by me
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user tries to delete written by him answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Delete'
      expect(page).to_not have_content answer.body
    end
  end

  scenario 'Authenticated user tries to delete not written by him answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(find('.answers')).to_not have_content 'Delete'
  end
end
