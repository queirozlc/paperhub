Rails.application.routes.draw do
  root "welcome#index"

  devise_for :users, path: "", controllers: {
    sessions: "users/sessions",
    verification: "users/onboarding",
    invitations: "users/invitations"
  }, skip: %i[verification]

  get "verify_email" => "users/confirmations#show", as: :verify_email

  get "onboarding" => "users/onboarding#show", as: :user_onboarding
  patch "onboarding" => "users/onboarding#update", as: :user_onboarding_update

  resources :documents, except: %i[new edit] do
    collection do
      delete "destroy_all" => "documents#destroy_all"
    end
  end

  resources :teams, only: %i[create]
  namespace :users do
    resources :teams, only: %i[update], controller: "profile"
  end


  get "up" => "rails/health#show", as: :rails_health_check
end
