Trunk::Application.routes.draw do

  resources :irregularities

  resources :dandies

  resources :cost_sheets

  resources :helicopters

  resources :helibases

  resources :items

  resources :incidents

  namespace :global do
    resources :enrollments
  end

  ##############################################################################
  ####################### ADMIN NAMESPACE BEGIN ################################
  ##############################################################################
  namespace :admin do
    #operation routes
    resources :operations, :only => :index, :module => "global"
    resources :operations, :except => :index

    #rappel routes
    resources :rappels, :only => [:update, :create, :destroy]
    match 'rappels/:id/confirm' => 'rappels#confirm', :as => :confirm_rappel, :via => :post

    #rostered_person routes
    resources :rostered_person
    match 'rostered_people' => 'rostered_person#index', :via => :get

    #spot routes
    resources :spots, :only => [:update, :destroy]
    match 'spots/:id/confirm' => 'spots#confirm', :as => :confirm_spot, :via => :post

    #certificate routes
    resources :certificates, :except => [:index, :new]

    #qualification routes
    resources :qualifications, :except => [:index, :new]

    #crew routes
    resources :crews, :only => [:new, :create, :destroy], :module => "global"
    #match 'crews/:id/:year' => 'crews#show', :as => :crew_year
    resources :crews, :except => [:new, :create, :destroy] do
      member do
        get 'enrollments' => 'crews#enrollments', :as => :enrollments_for
        get 'scheduled_courses' => 'crews#scheduled_courses', :as => :scheduled_courses_for
        get 'operations' => 'crews#operations', :as => :operations_for
        get 'training_facilities' => 'crews#training_facilities', :as => :training_facilities_for
        get 'roster/:year' => 'crews#roster', :as => :roster_for
        get 'qualifications' => 'crews#qualifications', :as => :qualifications_for
        get 'dandies' => 'crews#dandies', :as => :dandies_for
      end
    end


    #enrollment routes
    resources :enrollments, :only => :index, :module => "global"
    resources :enrollments, :only => :show, :constraints => {:id => /\d+/}
    resources :enrollments, :except => [:new, :show]

    #scheduled_course routes
    resources :scheduled_courses, :only => :index, :module => "global"
    resources :scheduled_courses, :except => :index

    #training_facility routes
    resources :training_facilities, :only => [:index, :edit, :new, :update, :destroy]

    #person routes
    resources :people, :only => [:create]
    resources :people do
      resources :certificates, :only => [:new,:create]
      resources :qualifications, :only => [:new,:create]
      #match ':year' => 'people#show', :as => :year
      member do
        get 'certificates' => 'people#certificates', :as => :certificates_for
        get 'qualifications' => 'people#qualifications', :as => :qualifications_for
        get 'operations' => 'people#operations', :as => :operations_for
        get 'enrollments' => 'people#enrollments', :as => :enrollments_for
        get 'destroy_login' => 'people#destroy_login', :as => :destroy_login_for, :via => :post
      end
    end

    #staffing_level routes
    resources :staffing_levels

  end

  ##############################################################################
  ####################### ADMIN NAMESPACE END ##################################
  ##############################################################################


  resources :frequencies do
    collection do
      post 'sort' #For AJAX draggable sorting feature
    end
  end
  
  resources :frequency_groups, :except => [:index, :show, :create]
  resources :frequency_groups, :only => [:update] do
    member do
      put 'update_frequencies' => 'frequency_groups#update_frequencies'
    end
  end
  resources :frequency_groups, :only => [:index, :show, :create] do
    member do
      get 'frequencies' => 'frequency_groups#frequencies', :as => :frequencies_for
      get 'test' => 'frequency_groups#test', :as => :test_for
    end
  end

  #region routes
  get 'region/:region_id' => 'crews#index', :as => :region

  #rostered_person routes
  resources :rostered_person
  get 'rostered_people' => 'rostered_person#index'

  #operation routes
  resources :operations, :except => [:show, :index], :module => "admin"
  resources :operations, :only => :index, :module => "global"
  resources :operations, :only => :show, :constraints => {:id => /\d+/}

  #crew routes

  resources :crews, :only => [:edit, :update], :module => "admin"
  resources :crews, :only => [:new, :create, :destroy], :module => "global"
  #match 'crews/:id/:year' => 'crews#show', :as => :crew_year #This breaks "crews/1/operations"
  resources :crews, :only => [:index, :show] do
    member do
      get 'enrollments' => 'crews#enrollments', :as => :enrollments_for
      get 'scheduled_courses' => 'crews#scheduled_courses', :as => :scheduled_courses_for
      get 'operations' => 'crews#operations', :as => :operations_for
      get 'training_facilities' => 'crews#training_facilities', :as => :training_facilities_for
      get 'qualifications' => 'crews#qualifications', :as => :qualifications_for
      #get 'rotation_board' => 'crews#rotation_board', :as => :rotation_board_for
      get 'robo' => 'crews#rotation_board', :as => :rotation_board_for
      get 'budget' => 'crews#requisitions', :as => :requisitions_for
    end
  end
  resources :crews do
    resources :requisitions, :only => [:new,:create]
  end
  match '/crews/:id/rotation_board' => "crews#create_rotation_board_state", :via => 'post', :as => "update_rotation_board_for_crew"
  match '/crews/:id/add_booster_to_rotation_board' => "crews#add_booster_to_rotation_board", :via => 'post', :as => "add_booster_to_rotation_board_for_crew"


  #rotation_board routes
  resources :rotation_board, :only => :show do
    member do
      get 'previous' => 'rotation_board#previous'
      get 'next' => 'rotation_board#next'
    end
  end

  #requisition routes
  resources :requisitions, :except => [:index]

  #enrollment routes
  resources :enrollments, :except => [:show, :index, :new], :module => "admin"
  resources :enrollments, :only => :index, :module => "global"
  resources :enrollments, :only => :show, :constraints => {:id => /\d+/}

  #scheduled_course routes
  resources :scheduled_courses, :except => [:show, :index], :module => "admin"
  resources :scheduled_courses, :only => :index, :module => "global"
  resources :scheduled_courses, :only => :show

  #certificates routes
  resources :certificates, :except => [:index, :new, :show], :module => "admin"
  resources :certificates, :only => [:show] do
    member do
      get 'download_attachment' => 'certificates#download_attachment', :as => :download_attachment_for
      get 'view_attachment' => 'certificates#view_attachment', :as => :view_attachment_for
    end
  end

  #qualifications routes
  resources :qualifications, :except => [:index, :new, :show], :module => "admin"
  get 'qualifications/autocomplete' => 'qualifications#autocomplete'
  resources :qualifications, :only => [:show] do
    member do
      get 'download_attachment' => 'qualifications#download_attachment', :as => :download_attachment_for
      get 'view_attachment' => 'qualifications#view_attachment', :as => :view_attachment_for
    end
  end

  #crew_address routes
  resources :crew_addresses

  #person_address routes
  resources :person_addresses
  
  #roster routes
  resources :rosters

  #training_facility routes
  resources :training_facilities, :module => "admin"

  #staffing_level routes
  resources :staffing_levels

  #rappel_equipment routes
  get 'rappel_equipment/autocomplete/:category' => 'rappel_equipment#autocomplete'

  #spotter routes
  get 'rappel_spotters/autocomplete' => 'rappel_spotters#autocomplete'

  #rappeller routes
  get 'rappellers/autocomplete' => 'rappellers#autocomplete'

  #pilot routes
  get 'pilots/autocomplete' => 'pilots#autocomplete'

  #forgotten password / password reset routes
  match 'forgotten_password' => 'people#forgotten_password', :via => :get, :as => 'forgotten_password'
  match 'reset_password' => 'people#reset_password', :via => :post, :as => 'reset_password'
  get 'signup' => 'people#signup', :as => 'signup'

  #person routes
  resources :people, :except => [:create, :destroy, :edit, :update] do
    resources :certificates, :only => :new, :module => "admin"
    resources :qualifications, :only => :new, :module => "admin"
    collection do
      get 'autocomplete'
    end
  end
  resources :people, :only => [:destroy, :edit, :update], :module => "admin"
  resources :people, :only => [:create]
  resources :people, :only => :show do
    member do
      get 'certificates' => 'people#certificates', :as => :certificates_for
      get 'qualifications' => 'people#qualifications', :as => :qualifications_for
      get 'operations' => 'people#operations', :as => :operations_for
      get 'enrollments' => 'people#enrollments', :as => :enrollments_for
    end
  end

  #session routes
  match 'login' => 'sessions#create', :as => :login, :via => :post
  get 'login' => 'sessions#new', :as => :login_form
  get 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'welcome#index'

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
