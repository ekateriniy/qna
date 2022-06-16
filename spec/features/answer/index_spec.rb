require 'rails_helper'

feature 'User can see all the answers to the question', %q{
  In order to see all answers given to the question
  As an unauthenticated user
  I'd like to be able to see all answers
} do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Get all answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('AnswerBody', count: 3)
  end
end
