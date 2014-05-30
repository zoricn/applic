BaseApp::Application.routes.draw do

  resources :attachments

  resources :request_attachments

  get "/position_requests/:token" => "position_requests#show", :as => "position_request"
  get "/positions/:token/position_requests/new" => "position_requests#new"


  resources :comments, :only => [:create, :new]


  # resources :position_requests, :except => [:destroy, :edit, :show] do
  #   member do
  #     put "accept"
  #     put "reject"
  #   end
  # end

  resources :positions do
    member do
      get 'position_requests'
    end
    resources :position_requests, :except => [:destroy, :show] do
      member do
        put "accept"
        put "reject"
        put 'archive'
        put "process_request"
      end
    end
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get "pages/index"

  get "/admin" => "admin/base#index", :as => "admin"

  namespace "admin" do

    resources :users

  end

  authenticated :user do
    root :to => "positions#index", as: :auth_root
  end

  root :to => "pages#index"

end
