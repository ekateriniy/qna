Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :cancel
    end
  end

  resources :users do
    resources :awards, only: :index
  end

  resources :questions do
    patch :update_best_answer, on: :member
    concerns :votable

    resources :answers, shallow: true, only: [:create, :destroy, :update] do
      concerns :votable
    end
  end

  namespace :active_storage do
    resources :attachments, only: [:destroy]
  end
  
  mount ActionCable.server => '/cable'
end
