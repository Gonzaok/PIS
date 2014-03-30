Focus::Application.routes.draw do

  scope "(:locale)", :locale => Languages_regexp do

    root :to => 'home#index'

    get "search/index"
    get "search/search_home"

    #Session routes
    match '/logout', :to => 'sessions#destroy'
    get '/sessions', :to => 'sessions#index'
    post '/sessions', :to => 'sessions#client_login'
    resource :session, :only => [:new, :create, :destroy]

    #moods routes
    resources :moods, :only => [:new, :create, :edit, :update, :destroy, :index]

    #Comments routes
    post "comments/update"
    delete "comments/destroy"
    resources :comments, :only => [:create, :update, :destroy]

    post "users/create_contact"

    #Forms routes
    get "forms/send_view"
    get "forms/get_projects"
    get "forms/form_summary"
    get "forms/summary"
    get "forms/summary_token"
    get "forms/show_summary"
    post "forms/send_form"
    resources :forms, :only => [:new, :create, :destroy, :index]

    #Contents routes
    get "contents/modify_visibility"
    post "contents/update"
    post "contents/content_ranking"
    get "contents/show_all_comments"
    resources :contents, :only => [:create, :update, :destroy]

    #Milestones routes
    resources :milestones, :only => [:create, :edit, :update, :destroy]

    #Project routes
    get "projects/my_projects"
    get "projects/file"
    resources :projects, :only => [:show, :new, :create, :destroy, :index]

    #Clients routes
    get "clients/my_client"
    resources :clients

    #User routes
    get "contents/update"
    get "contents/show_add"
    get "contents/show_edit"
    get "users/edit_profile"
    get "users/activity_list"
    get "users/edit_contact"
    put "users/update_profile"
    put "users/update_contact"
    get "users/toggle_admin"
    get "users/update"
    get "users/new_contact"
    get "users/change_my_profile"
    match '/signup', :to => 'users#new'
    resources :users, :only => [:create, :show, :destroy, :index]

    #Set Mood routes
    get "set_mood/create"
    match '/set_mood', :to => 'set_mood#set_mood'
    match '/set_comment', :to => 'set_mood#set_comment'
#    resources :set_moods

    resources :password_resets, :only => [:new, :create, :edit, :update]
  end

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
  #match ':controller(/:action(/:id))(.:format)'
end
