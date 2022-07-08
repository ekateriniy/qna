Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :users do
    resources :awards, only: :index
  end

  resources :questions do
    patch :update_best_answer, on: :member

    resources :answers, shallow: true, only: [:create, :destroy, :update]
  end

  namespace :active_storage do
    resources :attachments, only: [:destroy]
  end
end
