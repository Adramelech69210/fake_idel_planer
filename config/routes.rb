Rails.application.routes.draw do
  root to: "appointments#index"

  resources :appointments, except: [:edit, :new]

  resources :reports, only: [:index, :new, :create, :show, :update, :destroy] do
    collection do
      get :generate
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :patients do
    resources :notes, only: [:show, :new, :create, :update, :destroy]
    resources :pathologies, only: [:show, :new, :create, :update, :destroy]

    member do
      post :upload_ordonnance
      delete :destroy_ordonnance
    end
  end

  get "profile", to: "users#profile"
end
