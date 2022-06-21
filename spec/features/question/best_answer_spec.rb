require 'rails_helper'

feature 'Question author can mark an answer as the best', %q{
  To reduce other users searching time
  As an author of the question
  I'd like to be able to mark it as the best one
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }
  given(:other_user) { create(:user) }

  describe 'The question author', js: true do
    given!(:best_answer) { create(:answer, question: question, body: 'abcdefg') }
    given!(:other_answer) { create(:answer, question: question, body: 'other answer') }

    background do
      sign_in(user)
      visit question_path(question)

      within "#answer-body-#{best_answer.id}" do
        click_on 'Best answer'
      end
    end

    scenario 'marks answer as the best' do
      expect(find('.answers')).to_not have_content 'abcdefg'
      expect(find('.best-answer')).to have_content 'abcdefg'
    end

    scenario 'marks other answer as the best' do
      within "#answer-body-#{other_answer.id}" do
        click_on 'Best answer'
      end

      expect(find('.answers')).to_not have_content 'other answer'
      expect(find('.answers')).to have_content 'abcdefg'

      expect(find('.best-answer')).to have_content 'other answer'
      expect(find('.best-answer')).to_not have_content 'abcdefg'
    end
  end

  scenario "Authenticated user can not mark answer as the best for other user's question" do
    sign_in(other_user)
    visit question_path(question)
  
    expect(find('.answers')).to_not have_link 'Best answer'
  end


  scenario "Unauthenticated user can not mark answer as the best for other user's question" do
    visit question_path(question)
  
    expect(find('.answers')).to_not have_link 'Best answer'
  end
end