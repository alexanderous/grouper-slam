require 'sidekiq/web' #sidekiq GUI (see railscasts)

Antho::Application.routes.draw do


  resources :search_suggestions


  get "evangelists/index"
  #get "users/:login" => "users#show"


  resources :loves
  resources :password_resets
  resources :invites  
  #resources :loves, only: [:create, :destroy]

  resources :friends, :controller => "friendships", :except => [:show, :edit] do
      get "requests", :on => :collection
      get "invites", :on => :collection
  end

  resources :microposts do #does this make way for the rest of the micropost to be viewed?   
    resources :comments, :only => [:create, :destroy, :show, :index]

    member do
      get :show, :lovers, :loving, :loves, :show_lovers
    end
  end

  resources :users do
    member do
       get :following, :followers, :show_posts, :other_user_index, :kinships, :anthologies_managed
     end
    #'/:name' :controller => 'users', :action => 'show'

  end

  resources :evangelists
  resources :subjects

  resources :sessions, only: [:new, :create, :destroy]
  #resources :relationships, only: [:create, :destroy]



  root to: 'static_pages#home'

  match '/start',   to: 'users#new'
  match '/contribute', to: 'microposts#new'
  match '/signin',   to: 'sessions#new'
  match '/signout',  to: 'sessions#destroy', via: :delete

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/jobs',    to: 'static_pages#jobs'
  match '/anthologies', to: 'users#index'

  #match '/my_kinships', to: 'friendships#index'
  match '/requests', to: 'friendships#requests'
  match '/story_ticker', to: 'users#story_ticker'
  match '/self', to: 'users#self'
  #match '/their_kin', to: 'users#other_user_index'
  match '/evangelists', to: 'evangelists#index'
  match '/invite_request', to: 'evangelists#new'
  match '/stories_and_drafts', to: 'microposts#index'

  
  #match '/comments', to: 'microposts#showcomments'

  mount Sidekiq::Web, at: "/sidekiq" #sidekiq GUI
  #post 'microposts/autosave', as: :autosave_micropost_path
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
