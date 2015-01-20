Hermes::Application.routes.draw do
  devise_for :users

  root :to => 'sites#index'

  post '/sites/general_broadcast' => 'sites#general_broadcast', as: :general_broadcast

  resources :sites, except: :new do
    resources :tips, controller: 'site_tips'
    resources :tutorials
  end

  resources :tutorials, only: :show do
    resources :tips, controller: 'tutorial_tips'
  end

  put '/tips/:id/position'  => 'tips#position', as: :tip_position

  resources :messages, only: %w( index show ) do
    collection do
      get "tutorials"              => "messages#tutorials"
      get "tutorials/:tutorial_id" => "messages#tutorial"
    end

    member do
      get ":type" => "messages#update", as: :dismiss
    end
  end
end
