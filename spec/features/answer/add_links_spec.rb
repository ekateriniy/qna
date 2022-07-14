require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As the answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link_url) { 'https://github.com' }


  background { sign_in(user) }

  describe 'User adds links when giving an answer' do
    background do
      visit question_path(question)

      fill_in 'Body', with: 'Test`s body'
    end

    scenario 'with valid url', js: true do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: link_url
      click_on 'add link'

      page.all('.nested-fields').each do |field|
        within(field) do

          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: link_url
        end
      end
      
      click_on 'Post answer'

      within('.answers') do
        expect(page).to have_link 'My link', href: link_url, count: 2
      end
    end

    scenario 'with errors', js: true do
      within('.new-answer') do
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: 'plain text'
        
        click_on 'Post answer'
      end

      expect(page).to have_content 'Links invalid url must have url format'
      expect('.answers').to_not have_content 'My link'
    end
  end

  describe 'User adds link when editing the answer' do
    background do
      create(:answer, question: question, author: user)
      visit question_path(question)

      within('.answers') do
        click_on 'Edit'
        click_on 'add link'

        fill_in 'Link name', with: 'My link'
      end
    end

    scenario 'with valid url', js: true do
      within('.answers') do
        fill_in 'Url', with: link_url
        
        click_on 'Save'
      end

      expect(page).to have_link 'My link', href: link_url
    end

    scenario 'with errors', js: true do
      within('.answers') do
        fill_in 'Url', with: 'plain text'
        
        click_on 'Save'
      end

      expect(page).to have_content 'Links invalid url must have url format'
      expect('.answers').to_not have_content 'My link'
    end
  end
end
