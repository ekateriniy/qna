require 'rails_helper'

feature 'User can edit links belongs to his answer', %q{
  In order to correct additional info in my answer
  As the answer's author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, :for_answer, linkable: answer) }

  scenario 'User removes link when editing the qiestion', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answers') do
      click_on 'Edit'
      click_on 'remove link'
    end
    
    click_on 'Save'
    expect(page).to_not have_link 'answer link body'
  end
end
