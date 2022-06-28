require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As the question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ekateriniy/2368cfd40e09b995b6be0acc16fe1ffb' }

  background { sign_in(user) }

  describe 'User adds links when asking a qiestion' do
    background do
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test`s body'
    end

    scenario 'with valid url', js: true do
      click_on 'add link'

      page.all('.nested-fields').each do |field|
        within(field) do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url
        end
      end
      
      click_on 'Ask'
      expect(page).to have_link 'My gist', href: gist_url, count: 2
    end

    scenario 'with errors' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'plain text'
      
      click_on 'Ask'

      expect(page).to have_content 'Links invalid url must have url format'
    end
  end

  describe 'User adds link when editing the qiestion' do
    given!(:question) { create(:question, author: user) }

    background do
      visit question_path(question)
      within('.question') do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link name', with: 'My gist'
      end
    end

    scenario 'with valid url', js: true do
      within('.question') do
        fill_in 'Url', with: gist_url
        
        click_on 'Save'
      end

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'with errors', js: true do
      within('.question') do
        fill_in 'Url', with: 'plain text'
        
        click_on 'Save'
      end

      expect(page).to have_content 'Links invalid url must have url format'
    end
  end
end
