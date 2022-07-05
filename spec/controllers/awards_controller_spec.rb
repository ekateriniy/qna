require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'GET #index' do
    let!(:awards) { create_list(:award, 2, user: user) }
    before do
      login(user)
      get :index, params: { user_id: user }
    end

    it 'populates an array of all awards' do
      expect(assigns(:awards)).to match_array(awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
