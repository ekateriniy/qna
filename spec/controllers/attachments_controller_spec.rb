require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file, author: user) }
    before { login(user) }

    it 'deletes the attachment' do
      expect { delete :destroy, params: { id: question.files.last.id }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: question.files.last.id }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
