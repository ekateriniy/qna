require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As the question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ekateriniy/2368cfd40e09b995b6be0acc16fe1ffb' }
  given(:question) { create(:question, author: user) }

  background { sign_in(user) }

  scenario 'User adds links when asking a qiestion', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test`s body'
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

  scenario 'User adds link when editing the qiestion', js: true do
    visit question_path(question)

    within('.question') do
      click_on 'Edit'
      click_on 'add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      
      click_on 'Save'
    end
    expect(page).to have_link 'My gist', href: gist_url
  end
end
