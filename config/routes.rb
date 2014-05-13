BaseApp::Application.routes.draw do

  resources :applicants

  resources :position_requests, :except => [:destroy, :edit, :show] do
    member do
      put "accept"
      put "reject"
    end
  end

  get "/position_requests/:token" => "position_requests#show"

  resources :comments, :only => [:create, :new]

  resources :positions do
    member do
      get 'position_requests'
    end
      resources :position_requests, :except => [:destroy, :edit, :show] do
        member do
          put "accept"
          put "reject"
        end
      end
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get "pages/index"

  get "/admin" => "admin/base#index", :as => "admin"

  namespace "admin" do

    resources :users

  end

  root :to => "pages#index"

end
