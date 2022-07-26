require 'rails_helper'

feature 'Unauthenticated user can sign up', %q{
  In order to ask and answer questions
  As an unregistrated user
  I'd like to be able to sign up
} do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  describe 'Unregistered user' do
    scenario 'tries to sign up' do
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '1234567890'
      fill_in 'Password confirmation', with: '1234567890'

      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email'
    end

    scenario 'tries to sign up with errors' do
      fill_in 'Email', with: 'user@test.com'

      click_button 'Sign up'
      expect(page).to have_content 'prohibited this user from being saved'
    end
  end

  scenario 'Already registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_button 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end
