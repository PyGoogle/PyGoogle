# Route prefixes use a single letter to allow for vanity urls of two or more characters
Rails.application.routes.draw do

  if defined? Sidekiq
    require 'sidekiq/web'
    authenticate :user, lambda {|u| u.is_admin? } do
      mount Sidekiq::Web, at: '/admin/sidekiq/jobs', as: :sidekiq
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  # OAuth
  oauth_prefix = Rails.application.config.auth.omniauth.path_prefix
  get "#{oauth_prefix}/:provider/callback" => 'users/oauth#create'
  get "#{oauth_prefix}/failure" => 'users/oauth#failure'
  get "#{oauth_prefix}/:provider" => 'users/oauth#passthru', as: 'provider_auth'
  get oauth_prefix => redirect("#{oauth_prefix}/login")

  # Devise
  devise_prefix = Rails.application.config.auth.devise.path_prefix
  devise_for :users, path: devise_prefix,
    controllers: {registrations: 'users/registrations', sessions: 'users/sessions',
      passwords: 'users/passwords', confirmations: 'users/confirmations', unlocks: 'users/unlocks'},
    path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  devise_scope :user do
    get "#{devise_prefix}/after" => 'users/registrations#after_auth', as: 'user_root'
  end
  get devise_prefix => redirect('/a/signup')

  # User
  resources :users, path: 'u', only: :show do
    resources :authentications, path: 'accounts'
  end
  get '/home' => 'users#show', as: 'user_home'

  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'pages#home'

  # Static pages
  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'

  get '/disclaimer' => 'pages#disclaimer', as: 'disclaimer'
  get '/terms' => 'pages#terms', as: 'terms'
  get '/privacy' => 'pages#privacy', as: 'privacy'


  # Google plus
  # get '/googleplus' => 'googleplus#home', as: 'googleplus'
  # get '/googleplus/secondpage' 

  # get '/plus' => 'plus#home', as: 'plus'
  # get '/plus/second' 

  # Youtube
  get '/youtube' => 'youtube#home', as: 'youtube'
  get '/youtube/extract_iframe' => 'youtube#extract_iframe', as: 'youtube_extract_iframe'
  get '/youtube/mosaic_tile' => 'youtube#mosaic_tile', as: 'youtube_mosaic_tile'
  get '/youtube/another' 
 
  # Search
  get '/search' => 'search#home', as: 'search'
  get '/search/second' 

  # Chrome
  get '/chrome' => 'chrome#home', as: 'chrome'
  get '/chrome/second' 

  # Hangouts
  get '/hangouts' => 'hangouts#home', as: 'hangouts'
  get '/hangouts/second' 

  # Translate
  get '/translate' => 'translate#home', as: 'translate'
  get '/translate/second' 

  # Maps
  get '/maps' => 'maps#home', as: 'maps'
  get '/maps/second' 

  # gmail
  get '/gmail' => 'gmail#home', as: 'gmail'
  get '/gmail/second' 

  # drive
  get '/drive' => 'drive#home', as: 'drive'
  get '/drive/second' 

  # gmail
  get '/calendar' => 'calendar#home', as: 'calendar'
  get '/calendar/second' 

  # play
  get '/play' => 'play#home', as: 'play'
  get '/play/second' 

  # google projects
  get '/projects' => 'projects#home', as: 'projects'
  get '/projects/second' 
  get '/projects/skybender' => 'projects#skybender', as: 'projects_skybender'
  get '/projects/skybender/second' 
end
