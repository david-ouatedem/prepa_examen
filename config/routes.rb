Rails.application.routes.draw do
  resources :exams
  root "home#index"
  get "home/admin"
  get "up" => "rails/health#show", as: :rails_health_check
  get 'locale/:locale', to: 'locale#switch', as: :switch_locale
end
