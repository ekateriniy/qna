require 'rails_helper'

feature "User can vote for other user's answer", %q{
  In order to express my opinion
  As the non answer author
  I'd like to be able to vote for it
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question) }

  describe 'Authenticated and not the answer author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up' do
      within("#answer-body-#{answer.id}") do  
        find('#upvote').click

        within('.votes') do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down' do
      within("#answer-body-#{answer.id}") do  
        find('#downvote').click

        within('.votes') do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote twice' do
      within("#answer-body-#{answer.id}") do
        find('#upvote').click
        find('#upvote').click
      
        within('.votes') do
          expect(page).to have_content '1'
          expect(page).to have_content 'User can vote only once for each object'
        end
      end
    end

    scenario 'cancels his vote' do
      within("#answer-body-#{answer.id}") do
        find('#downvote').click
        click_on 'cancel vote'
      
        within('.votes') do
          expect(page).to have_content '0'
        end
      end
    end
  
    scenario 'revotes' do
      within("#answer-body-#{answer.id}") do
        find('#downvote').click
        click_on 'cancel vote'
        find('#upvote').click
        
        within('.votes') do
          expect(page).to have_content '1'
        end
      end
    end
  end

  scenario 'Author of the answer tries to vote for himself' do
    sign_in(author)
    visit question_path(question)
    
    within("#answer-body-#{answer.id}") do
      expect(page).to_not have_css '#like'
    end
  end
  
  scenario 'Unauthenticated user tries to vote' do
    visit question_path(question)
    
    expect(page).to_not have_css '#like'
  end
end
