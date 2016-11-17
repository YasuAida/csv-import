Rails.application.routes.draw do

  root 'subexpenses#index'

  resources :return_goods, only: [ :index, :create, :update, :destroy] do
    collection do
      get 'import'
    end
  end

  resources :multi_channels, only: [ :index, :update] do
    collection do
      get 'import'
    end
  end

  get 'journalpatterns/index'

  get 'generalledgers/index'

  get 'expenseledgers/index'
  
  resources :stockledgers, only: [:index] do
    collection do
      get 'stock_list'
    end
  end

  get 'allocationcosts/index'

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

  resources :subexpenses, only: [ :create]

  resources :stocks, only: [ :index, :create, :update, :destroy] do
    collection do
      post 'upload'       
      get 'sku'
    end
  end
  
  resources :pladmins , only: [:index, :create, :update]

  resources :sales , only: [:index] do
    collection do
      post 'upload'
      get  'pladmin'
    end
  end

  get 'entrypatterns/index'
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
