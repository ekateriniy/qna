require 'rails_helper'

feature 'User can see his awards', %q{
  In order to find my achievement
  As an authenticated user
  I'd like to be able to see my awards
} do
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:award) {create(:award, question: question, user: user) }
  

  scenario 'Get all awards' do
    sign_in(user)
    visit user_awards_path(user)

    expect(page).to have_content(award.title)
    expect(page).to have_content(question.title)
    expect(page).to have_css('img')
  end
end
