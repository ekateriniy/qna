require 'rails_helper'

feature 'User can create award for the best answer', %q{
  In order to thank best answer's author
  As an author of the question
  I'd like to be able to create an award
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)

    visit new_question_path
    within('.new-question-form') do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'
    end
  end

  scenario 'create award' do
    within('#award') do
      fill_in 'Award title', with: 'New award'
      attach_file 'File', "#{Rails.root}/spec/support/images/kopi_tabao.jpg"
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
  end

  scenario 'create award with errors' do
    within('#award') do
      fill_in 'Award title', with: ''
      attach_file 'File', "#{Rails.root}/spec/support/images/kopi_tabao.jpg"
    end

    click_on 'Ask'

    expect(page).to have_content "Award title can't be blank"
  end
end
