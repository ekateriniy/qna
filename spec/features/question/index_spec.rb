require 'rails_helper'

feature 'User can see all questions', %q{
  In order to find any question
  As an unauthenticated user
  I'd like to be able to see all questions
} do
  given!(:questions) { create_list(:question, 3) }

  scenario 'Get all questions' do
    visit questions_path

    expect(page).to have_link 'Ask question', href: new_question_path
    expect(page).to have_content('MyString', count: 3)
    expect(page).to have_content('MyText', count: 3)
  end
end
