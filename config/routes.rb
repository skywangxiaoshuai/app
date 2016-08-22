Rails.application.routes.draw do




  get 'password_resets/new'

  get 'password_resets/edit'

  get '/help' , to:  'static_pages#help'

  get '/about',  to:  'static_pages#about'

  get  '/contact',  to:  'static_pages#contact'

  get  '/signup',  to:  'users#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    root  'static_pages#home'

    resources  :users

    get  '/login',    to:  'sessions#new'

    post  '/login',  to:  'sessions#create'

    delete  '/logout',  to:  'sessions#destroy'

    resources  :account_activations,  only:  [:edit]

    resources  :password_resets,  only:  [:new,  :edit,  :create,  :update]

    resources  :microposts,  only:  [:create,  :destroy]

end