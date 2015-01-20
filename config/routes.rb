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

  # tutorials (from client)
  get "/messages/tutorials.js"                   => "messages#tutorials"
  get "/messages/tutorials/:tutorial_id.js"      => "messages#tutorial"
  get "/message/tutorial/:tutorial_id/:type/:id" => "messages#show_tutorial_message", as: :message_tutorial

  # messages (from client)
  get "/messages.js"        => "messages#index"
  get "/messages/:type/:id" => "messages#update", as: :dismiss_message
  get "/message/:type/:id"  => "messages#show",   as: :message
end
