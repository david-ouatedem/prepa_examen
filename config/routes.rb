Rails.application.routes.draw do
  root "home#index"
  namespace :admin do
    resources :exams
    root to: "exams#index"
  end
  get "up" => "rails/health#show", as: :rails_health_check
  get 'locale/:locale', to: 'locale#switch', as: :switch_locale
end
