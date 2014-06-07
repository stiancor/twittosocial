SampleApp::Application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy, :who_likes] do
    resources :likes, only: [:create, :destroy]
    member do
      get :who_likes
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :event_invites
  resources :events do
    resources :event_comments, only: [:create]
  end


  root to: 'static_pages#home'

  match '/signup', to: 'users#new'
  match '/forgotten_password', to: 'users#forgotten_password'
  match '/send_password_link', to: 'users#send_password_link'
  match '/reset_password/:uuid', to: 'users#show_reset_password'
  match '/reset_password', to: 'users#reset_password'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/sessions', to: 'sessions#create'

  match '/help', to: 'static_pages#help'
  match '/contact', to: 'static_pages#contact'
  match '/about', to: 'static_pages#about'

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
