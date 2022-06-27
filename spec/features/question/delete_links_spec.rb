require 'rails_helper'

feature 'User can edit links belongs to his question', %q{
  In order to correct additional info in my question
  As the question's author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:link) { create(:link, :for_question, linkable: question) }

  scenario 'User removes link when editing the qiestion', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question') do
      click_on 'Edit'
      click_on 'remove link'
    end
    
    click_on 'Save'
    expect(page).to_not have_link 'question link body'
  end
end
