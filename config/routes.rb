Rails.application.routes.draw do

  get 'admin/login', to: 'admin#login', as: :admin
  mount Bhf::Engine, at: 'admin'

  resources :notices do
    get :first_step, on: :collection
    post :first_step, on: :collection
    get :second_step, on: :member
    patch :second_step, on: :member
    get :third_step, on: :member
    patch :third_step, on: :member
    get :share, on: :member
    patch :share, on: :member
    patch :enable, on: :member
    patch :disable, on: :member
    patch :burn, on: :member
    post :bulk, on: :collection
  end
  resources :users do
    get :confirmation_mail, on: :member
  end
  resources :google_auth_connections do
    patch :connect, on: :member
  end
  resources :beta_users do
    get :thank_you, on: :member
    get :invite, on: :member
  end
  resources :articles

  resource :sitemap, only: :show

  scope '/p' do
    get  '/open/:token',  to: 'public#open',  as: :open
    post '/read',         to: 'public#read',  as: :read
  end

  scope '/auth' do
    get  '/offline_login/:nickname', to: 'sessions#offline_login' if Rails.env.development?
    get  '/:provider/callback',      to: 'sessions#create'
    get  '/failure',                 to: 'sessions#failure'
    get  '/destroy_session',         to: 'sessions#destroy',    as: :logout
    get  '/validation/:token',       to: 'sessions#validation', as: :validation
    get  '/signup',                  to: 'sessions#signup',     as: :signup
    get  '/login',                   to: 'sessions#login',      as: :login
    get  '/connection',              to: 'sessions#connection', as: :connection
    post '/complete',                to: 'sessions#complete',   as: :complete
  end

  root 'beta_users#index'

  get 'blog', to: "articles#index"
  get 'beta', to: "beta_users#index"
  get 'faq',  to: "home#faq"

  get 'styleguide', to: "styleguide#index"

  get 'ping', to: -> (env) { [200, {"Content-Type" => "text/html"}, ["pong"]] }
end
