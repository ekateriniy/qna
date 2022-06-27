require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As the question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ekateriniy/2368cfd40e09b995b6be0acc16fe1ffb' }

  scenario 'User adds links when asks a qiestion' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test`s body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
