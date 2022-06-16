require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer) }

    it 'destroys the answer from the database' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question show view' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(assigns(:answer).question)
    end
  end
end
