Rails.application.routes.draw do
  root to: "appointments#index"
  resources :appointments, except: [:edit]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :patients do
    resources :notes
    resources :pathologies
    member do
      post :upload_ordonnance
      delete :destroy_ordonnance
    end
  end

  get "profile" => "users#profile"
end
