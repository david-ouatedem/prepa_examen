Rails.application.routes.draw do
  root "home#index"
  namespace :admin do
    resources :subjects
    resources :exams
    resources :specialities
    root to: "exams#index"
  end
  namespace :api do
    resources :specialities, only: [:index]
    resources :subjects, only: [:index]
  end
  get "up" => "rails/health#show", as: :rails_health_check
  get 'locale/:locale', to: 'locale#switch', as: :switch_locale
end
