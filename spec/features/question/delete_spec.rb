require 'rails_helper'

feature 'User can delete written question', %q{
  In order to delete written question
  As an authenticated user
  I'd like to be able to delete question, written by me
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user tries to delete written by him question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'All questions'
  end

  scenario 'Authenticated user tries to delete not written by him answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
