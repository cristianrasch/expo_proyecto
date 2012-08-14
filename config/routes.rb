ExpoProyecto::Application.routes.draw do
  match "venue" => "welcome#venue"

  match 'current_session' => 'current_session#show'

  get "requirements/index"

  devise_for :users

  resources :expositions, :path => :expos, :shallow => true do
    resources :projects do
      member do 
        get "prev"
        get "next"
      end
      
      get :gallery, :on => :collection
    end
    resources :activities
  end
  match 'expos/:id/summary' => 'expositions#summary', :as => :exposition_summary
  match 'expos/:exposition_id/tags' => 'tags#index', :as => :exposition_tags
  match 'expos/:exposition_id/requirements' => 'requirements#index', :as => :exposition_requirements
  
  resources :messages, :only => [:new, :create]
  
  root :to => "welcome#index"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
