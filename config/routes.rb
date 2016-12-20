Rails.application.routes.draw do

  resources :selfstorages, only: [ :index, :create, :update, :destroy]
  
  resources :disposals, only: [ :index, :create, :update, :destroy]
  
  resources :periods, only: [ :index, :create]

  resources :financial_statements, only: [ :index] do
    collection do
      get 'bs'
      get 'pl'
    end
  end
  
  get 'sessions/new'

  root to: 'top_pages#index'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users
  
  get 'top_pages/index'

  resources :top_pages, only: [ :index] do
    collection do
      get 'download'
      post 'upload'
    end
  end
  
  resources :vouchers, only: [ :index, :create, :update, :destroy]

  resources :return_goods, only: [ :index, :create, :update, :destroy]

  resources :multi_channels, only: [ :index, :update] do
    collection do
      get 'sku'
    end
  end

  get 'journalpatterns/index'

  resources :generalledgers, only: [:index, :destroy] do
    collection do
      get 'show'
    end    
  end

  resources :expenseledgers, only: [ :index, :create, :update, :destroy]

  resources :stockledgers, only: [:index, :create, :update, :destroy] do
    collection do
      get 'import'      
      get 'stock_list'
    end
  end

  resources :allocationcosts, only: [:index] do
    collection do
      get 'show'
    end    
  end
  
  resources :currencies, only: [:index, :create, :destroy]

  resources :exchanges, only: [:index, :create, :update, :destroy] do
    collection do
      post 'upload'
    end
  end

  resources :stockaccepts, only: [:index] do
    collection do
      post 'upload'
    end
  end

  resources :listingreports, only: [:index] do
    collection do
      post 'upload'
    end
  end  

  resources :expense_titles, only: [ :index, :create, :update, :destroy]

  resources :subexpenses, only: [ :index, :create, :show, :update, :destroy] 

  resources :stocks, only: [ :index, :create, :update, :destroy] do
    collection do
      post 'upload'       
      get 'sku'
      get 'plural_destroy'
    end
  end
  
  resources :pladmins , only: [:index, :create, :update, :destroy] do
    collection do
      get 'blank_form'
      post 'upload'     
    end
  end

  resources :sales , only: [:index] do
    collection do
      post 'upload'
      get  'handling'
      get  'pladmin'
    end
  end
  
  resources :accounts, only: [ :index, :create, :update, :destroy]

  resources :entrypatterns, only: [ :index, :create, :update, :destroy]
  
  get 'expense_methods/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
