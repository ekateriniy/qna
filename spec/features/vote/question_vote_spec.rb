require 'rails_helper'

feature "User can vote for other user's question", %q{
  In order to express my opinion
  As the non question author
  I'd like to be able to vote for it
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated and not the question author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up' do
      find('#upvote').click
      
      within('.votes') do
        expect(page).to have_content '1'
      end
    end

    scenario 'votes down' do
      find('#downvote').click
      
      within('.votes') do
        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to vote twice' do
      find('#upvote').click
      find('#upvote').click
      
      within('.votes') do
        expect(page).to have_content '1'
        expect(page).to have_content 'User can vote only once for each object'
      end
    end

    scenario 'cancels his vote' do
      find('#downvote').click
      click_on 'cancel vote'
      
      within('.votes') do
        expect(page).to have_content '0'
      end
    end
  
    scenario 'revotes' do
      find('#downvote').click
      click_on 'cancel vote'
      find('#upvote').click
      
      within('.votes') do
        expect(page).to have_content '1'
      end
    end
  end

  scenario 'Author of the question tries to vote for himself' do
    sign_in(author)
    visit question_path(question)

    expect(page).to_not have_css '#like'
  end
  
  scenario 'Unauthenticated user tries to vote' do
    visit question_path(question)
    
    expect(page).to_not have_css '#like'
  end
end
