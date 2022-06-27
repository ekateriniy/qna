require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns new links to question.links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:question) { create(:question) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        question.reload
        expect(question.body).to eq 'new body'
        expect(question.title).to eq 'new title'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
      
      it 'does not change question attributes' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #update_best_answer' do
    before { login(user) }
    let!(:question) { create(:question, author: user) }
    let!(:answers) { create_list(:answer, 2, question: question) }

    it 'updates question best answer' do
      patch :update_best_answer, params: { id: question, answer_id: answers[0] }, format: :js

        question.reload
        expect(question.best_answer).to eq answers[0]
    end

    it 'renders update_best_answer view' do
      patch :update_best_answer, params: { id: question, answer_id: answers[0] }, format: :js

      expect(response).to render_template :update_best_answer
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
