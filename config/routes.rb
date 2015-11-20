PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do
    member do
      post :vote
    end

    #collection is where we put routes that do not
    #pertain to individual posts
    #GET /posts/archives
    #collection do
    #  get :archives
    #end

    resources :comments, only: [:create] do
      member do
        post :vote
      end
    end
   # resources :votes, only: [:create]  # this would do a /posts/:id/votes => votes#create
  end
  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create, :edit, :show, :update]
end
