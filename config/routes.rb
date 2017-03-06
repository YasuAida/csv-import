Rails.application.routes.draw do
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

  resources :administraters, only: [ :index] do
    collection do
      get 'admin_download'
      post 'admin_upload'
    end
  end

  get 'settings/index'

  resources :selfstorages, only: [ :index, :create, :update, :destroy]

  
  resources :periods, only: [ :index, :create]

  resources :financial_statements, only: [ :index] do
    collection do
      get 'bs'
      get 'pl'
    end
  end

  resources :generalledgers, only: [:index, :destroy] do
    collection do
      get 'show'
    end    
  end

  resources :stockledgers, only: [:index] do
    collection do
      get 'show'      
      get 'stock_list'
    end
  end

  resources :allocationcosts, only: [:index] do
    collection do
      get 'show'
    end    
  end

  resources :expense_titles, only: [ :index, :create, :update, :destroy]
  get 'expense_titles/show'


  resources :subexpenses, only: [ :index, :create, :show, :update] 
  get 'subexpenses/destroy'
  
  resources :accounts, only: [:index, :new, :create, :edit, :update]
  get 'accounts/destroy'

  resources :currencies, only: [:index, :new, :create, :edit, :update]
  get 'currencies/destroy'

  resources :disposals, only: [ :index, :new, :create, :edit, :update]do
    member do
      get 'copy'      
    end
  end
  get 'disposals/destroy'

  resources :dummy_stocks , only: [ :index, :new, :create, :edit, :update]   
  get 'dummy_stocks/destroy'
  
  resources :entrypatterns, only: [ :index, :new, :create, :edit, :update]do
    member do
      get 'copy'      
    end
  end
  get 'entrypatterns/destroy' 

  get 'expense_methods/index'

  resources :exchanges, only: [:index, :new, :create, :edit, :update] do
    collection do
      post 'upload'
    end
  end
  get 'exchanges/destroy'
  
  resources :expenseledgers, only: [ :index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
    collection do
      get 'blank_form'
      post 'upload'     
    end
  end
  get 'expenseledgers/destroy'

  resources :journalpatterns, only: [ :index, :new, :create, :edit, :update]do
    member do
      get 'copy'      
    end
  end
  get 'journalpatterns/destroy'

  resources :listingreports, only: [:index, :edit, :update] do
    collection do
      post 'upload'
    end
  end  
  
  resources :multi_channels, only: [:index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
    collection do
      get 'sku'
    end
  end
  get 'multi_channels/destroy'
 
  resources :pladmins , only: [:index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
    collection do
      get 'blank_form'
      post 'upload'     
    end
  end
  get 'pladmins/destroy'

  resources :rakuten_costs, only: [ :index, :new, :create, :edit, :update]do
    collection do
      post 'pc_upload'
      post 'mobile_upload'       
    end
  end
  get 'rakuten_costs/destroy'

  resources :rakuten_settings, only: [ :index, :new, :create, :edit, :update] do
  end  
  get 'rakuten_settings/destroy'
  
  resources :rakutens, only: [ :index, :new, :create, :edit, :update] do
    member do
      get 'copy'
      get 'edit_nyukin'
    end
    collection do
      get 'upload'
      get 'nyukin'
      get 'commission'
      get 'blank_form'
      post 'past_data_upload'
      post 'past_point_upload'      
      post 'csv_upload'
      post 'point_upload'
      post 'credit_upload'
      post 'bank_upload'
      post 'multi_upload' 
      post 'rakuten_upload'       
    end
  end
  get 'rakutens/destroy'

  resources :return_goods, only: [ :index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
  end
  get 'return_goods/destroy'

  resources :sales , only: [:index, :edit, :update] do
    collection do
      post 'upload'
      get  'handling'
      get  'pladmin'
      get  'receipt'      
    end
  end
 
  resources :stockaccepts, only: [:index, :edit, :update] do
    collection do
      post 'upload'
    end
  end
 
  resources :stockreturns , only: [ :index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
  end
  get 'stockreturns/destroy'
  
  resources :stocks, only: [ :index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
    collection do
      post 'upload'
      get 'sku'
    end
  end
  get 'stocks/destroy'
  
  resources :vouchers, only: [ :index, :new, :create, :edit, :update]do
    member do
      get 'copy'      
    end
    collection do
      get 'blank_form'
      post 'upload'
    end
  end
  get 'vouchers/destroy'
  
  resources :yafuokus , only: [ :index, :new, :create, :edit, :update] do
    member do
      get 'copy'      
    end
    collection do
      get 'blank_form'
      post 'upload'     
    end
  end
  get 'yafuokus/destroy'
  
  resources :yahoo_shoppings, only: [ :index, :new, :create, :edit, :update]do
    member do
      get 'copy'      
    end
    collection do
      post 'receipt_upload' 
      post 'payment_upload'       
    end
  end
  get 'yahoo_shoppings/destroy'

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