Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    patch :update_best_answer, on: :member

    resources :answers, shallow: true, only: [:create, :destroy, :update]
  end
end
