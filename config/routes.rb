Rails.application.eager_load! if Rails.env.development?

class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Peatio::Application.routes.draw do
  use_doorkeeper

  root 'welcome#index'

  if Rails.env.development?
    mount MailsViewer::Engine => '/mails'
  end

   #auth controller
  get "auth/login" => 'auth#login', as: 'login'
  get "auth/signup" => 'auth#signup', as: 'auth_signup'
  get "auth/safewex_usb" => 'auth#safewex_usb', as: 'login_safewex_usb'
  get "auth/paper_wallet" => 'auth#paper_wallet', as: 'login_paper_wallet'
  get "auth/private_and_public_key" => 'auth#private_and_public_key', as: 'login_private_and_public_key'
  post "auth/loginh" => 'auth#loginh', as: 'loginh'
  get "auth/username_and_password" => 'sessions#new', as: 'login_username_and_password' 
  get "auth/json" => 'auth#json', as: 'login_json'
  post '/auth/json_login', to: 'auth#json_login', as: 'auth_json_login'

  get '/signin' => 'sessions#new', :as => :signin
  get '/signup' => 'identities#new', :as => :signup
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure', :as => :failure
  get '/registration1' => 'identities#registration1', :as => :registration1
  post '/registration2' => 'identities#registration2', :as => :registration2
  #post '/registration2' => 'sessions#create_anonymous_user', :as => :createanonymoususer
  get '/wallet' => 'identities#wallet', :as =>:wallet
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]

  resource :member, :only => [:edit, :update]
  resource :identity, :only => [:edit, :update]

  namespace :verify do
    resource :sms_auth,    only: [:show, :update]
    resource :google_auth, only: [:show, :update, :edit, :destroy]
  end

  namespace :authentications do
    resources :emails, only: [:new, :create]
    resources :identities, only: [:new, :create]
    resource :weibo_accounts, only: [:destroy]
  end

  scope :constraints => { id: /[a-zA-Z0-9]{32}/ } do
    resources :reset_passwords
    resources :activations, only: [:new, :edit, :update]
  end
 
  get '/documents/api_v2'
  get '/documents/websocket_api'
  get '/documents/oauth'
  resources :documents, only: [:show]
  resources :two_factors, only: [:show, :index, :update]

  scope module: :private do
    resource  :id_document, only: [:edit, :update]

    resources :settings, only: [:index]
    resources :api_tokens do
      member do
        delete :unbind
      end
    end

    resources :fund_sources, only: [:create, :update, :destroy]

    resources :funds, only: [:index] do
      collection do
        post :gen_address
      end
    end

    namespace :deposits do
      Deposit.descendants.each do |d|
        resources d.resource_name do
          collection do
            post :gen_address
          end
        end
      end
    end

    namespace :withdraws do
      Withdraw.descendants.each do |w|
        resources w.resource_name
      end
    end

    resources :account_versions, :only => :index

    resources :exchange_assets, :controller => 'assets' do
      member do
        get :partial_tree
      end
    end

    get '/history/orders' => 'history#orders', as: :order_history
    get '/history/trades' => 'history#trades', as: :trade_history
    get '/history/account' => 'history#account', as: :account_history

    resources :markets, :only => :show, :constraints => MarketConstraint do
      resources :orders, :only => [:index, :destroy] do
        collection do
          post :clear
        end
      end
      resources :order_bids, :only => [:create] do
        collection do
          post :clear
        end
      end
      resources :order_asks, :only => [:create] do
        collection do
          post :clear
        end
      end
    end

    post '/pusher/auth', to: 'pusher#auth'

    resources :tickets, only: [:index, :new, :create, :show] do
      member do
        patch :close
      end
      resources :comments, only: [:create]
    end

  end
  post '/webhooks/tx' => 'webhooks#tx'
  post '/webhooks/eth' => 'webhooks#eth'

  draw :admin
  mount APIv2::Mount => APIv2::Mount::PREFIX

  
  resources :developers, only: [:index] 
  resources :calculators, only: [:index] 
  resources :dashboard, only: [:index] 
  resources :coins, only: [:index] 
  get '/articles/safewex', to: 'articles#safewex', as: 'safewex'
  get '/articles/protect_yourself', to: 'articles#protect_yourself', as: 'protect_yourself'
  get '/articles/bitcoin_wallet', to: 'articles#bitcoin_wallet', as: 'bitcoin_wallet'
  get '/articles/hardware_wallets', to: 'articles#hardware_wallets', as: 'hardware_wallets'
  get '/wallets/mergewallets', to: 'wallets#mergewallets', as: 'mergewallets'
  get '/wallets/designedwallets', to: 'wallets#designedwallets', as: 'designedwallets'
  get '/wallets/personal_wallets', to: 'wallets#personal_wallets', as: 'personal_wallets'
  get '/wallets/registration', to: 'wallets#registration', as: 'registration'

  
  #news controller
  get '/news/(:page)', to: 'news#index', as: 'news'
  get '/story/:id', to: 'news#story', as: 'story'
  
  #news admin controller
  get '/newsadmin/all/:page', to: 'newsadmin#all', as: 'newsadmin_all'
  get '/newsadmin/add_story', to: 'newsadmin#add_story', as: 'newsadmin_add_story'
  post '/newsadmin/save_story', to: 'newsadmin#save_story', as: 'newsadmin_save_story'
  get '/newsadmin/edit_story/:story_id', to: 'newsadmin#edit_story', as: 'newsadmin_edit_story'
  post '/newsadmin/update_story', to: 'newsadmin#update_story', as: 'newsadmin_update_story'
  get '/newsadmin/delete_story/:story_id', to: 'newsadmin#delete_story', as: 'newsadmin_delete_story'

  #chat controller
  get '/chat', to: 'chat#index', as: 'chat'
  post '/save_chat_message', to: 'chat#save_chat_message', as: 'save_chat_message'
  post '/load_chat_messages', to: 'chat#messages', as: 'chat_messages'
  get 'last_message_timestamp', to: 'chat#last_message_timestamp', as: 'last_message_timestamp'

  #chat admin controller
  get '/chatadmin/all/:page', to: 'chatadmin#all', as: 'chatadmin_all'
  get '/chatadmin/add_chatmessage', to: 'chatadmin#add_chatmessage', as: 'chatadmin_add_chatmessage'
  post '/chatadmin/save_chatmessage', to: 'chatadmin#save_chatmessage', as: 'chatadmin_save_chatmessage'
  get '/chatadmin/edit_chatmessage', to: 'chatadmin#edit_chatmessage', as: 'chatadmin_edit_chatmessage'
  post '/chatadmin/update_chatmessage', to: 'chatadmin#update_chatmessage', as: 'chatadmin_update_chatmessage'
  get '/chatadmin/delete_chatmessage/:chatmessage_id', to: 'chatadmin#delete_chatmessage', as: 'chatadmin_delete_chatmessage'
  get '/chatadmin/delete_chathistory', to: 'chatadmin#delete_chathistory', as: 'chatadmin_delete_chathistory'



end
