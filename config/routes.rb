Rails.application.routes.draw do

  # ------------------------------------------ Robots

  get 'robots.:format' => 'robots#show'

  # ------------------------------------------ API

  namespace :api do
    namespace :v2 do
      get 'authenticate' => 'base#test'
      # resources :forms, :only => [:create]
      post 'sites' => 'sites#create'
      post 'sites/update' => 'sites#update'
      # post 'sites/deploy' => 'sites#deploy'
      post 'users' => 'users#create'
      post 'data/export' => 'data#export'
    end
  end
  get 'api/*path' => 'api/v2/base#missing', :as => :api_missing

  # ------------------------------------------ Devise

  devise_for :users, :skip => [:sessions, :registrations]
  devise_scope :user do
    get '/login' => 'devise/sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session
    get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # ------------------------------------------ Editor

  resources :sites, :param => :uid, :path => '', :only => [:show] do
    get '/' => 'editor/base#home' # Redirects hanging URI segments

    namespace :editor do
      get '/' => 'base#home' # Redirects hanging URI segments

      resources :pages, :only => [:index, :new]

  #     # Site Settings
  #     get 'settings/croppers' => 'sites#croppers', :as => :cropper
  #     patch 'settings/croppers' => 'sites#update_croppers',
  #           :as => :update_croppers
  #     resources :site_settings, :controller => 'sites/settings', :param => :slug

  #     # Site Actions
  #     post 'pull' => 'sites#pull', :as => :pull
  #     post 'import' => 'sites#import', :as => :import
  #     post 'backup' => 'sites#backup', :as => :backup
  #     post 'symlink' => 'sites#symlink', :as => :symlink

  #     # Pages
  #     resources :pages, :param => :slug do
  #       resources :documents, :only => [:index, :create, :destroy],
  #                 :controller => 'pages/documents', :path => :library, :param => :idx
  #       resources :resource_types, :param => :slug, :path => :resources,
  #                 :only => [] do
  #         resources :resources, :except => [:show], :path => :associations,
  #                   :controller => 'pages/resources'
  #       end
  #       get 'move' => 'pages#move', :as => :move
  #       get 'settings/:slug' => 'pages#edit', :as => :settings
  #       get 'help' => 'pages#help', :as => :help
  #       post 'publish' => 'pages#publish', :as => :publish
  #       post 'unpublish' => 'pages#unpublish', :as => :unpublish
  #     end

  #     # Templates
  #     resources :templates, :param => :slug, :path_names => {
  #       :edit => :settings } do
  #       resources :template_fields, :path => :fields,
  #         :controller => 'templates/fields', :param => :slug do
  #           post 'hide' => 'templates/fields#hide', :as => :hide
  #           post 'show' => 'templates/fields#show', :as => :show
  #       end
  #       resources :template_groups, :path => :groups,
  #         :controller => 'templates/groups', :param => :slug
  #       resources :pages, :controller => 'templates/template_pages',
  #         :param => :slug, :only => [:index]
  #     end

  #     # Menus
  #     resources :menus, :param => :slug do
  #       resources :menu_items, :path => :items, :controller => 'menus/items',
  #                 :param => :slug
  #     end

  #     # Resources
  #     resources :resource_types, :path => :resources,
  #               :controller => :resources, :param => :slug, :path_names => {
  #               :edit => :settings } do
  #         resources :resources, :path => :items,
  #                   :controller => 'resources/items', :param => :slug
  #         resources :resource_fields, :path => :fields,
  #                   :controller => 'resources/fields', :param => :slug do
  #             post 'hide' => 'resources/fields#hide', :as => :hide
  #             post 'show' => 'resources/fields#show', :as => :show
  #         end
  #         resources :resource_association_fields, :path => :association_fields,
  #                   :controller => 'resources/association_fields', :param => :slug do
  #             post 'hide' => 'resources/association_fields#hide', :as => :hide
  #             post 'show' => 'resources/association_fields#show', :as => :show
  #         end
  #     end

  #     # Forms
  #     resources :forms, :param => :slug do
  #       resources :form_submissions, :path => :submissions, :param => :idx,
  #         :controller => 'forms/submissions', :except => [:new, :create]
  #       resources :form_fields, :path => :fields,
  #         :controller => 'forms/fields', :param => :slug
  #     end

  #     # Files
  #     get 'library/max_file_size' => 'documents#max_file_size'
  #     resources :documents, :path => :library, :param => :idx,
  #       :except => [:show] do
  #         get 'crop' => 'documents/croppings#edit', :as => :cropper
  #         patch 'crop' => 'documents/croppings#update', :as => :crop
  #     end

  #     # Users
  #     resources :users, :except => [:show]
  #   end
    end
  end

  # ------------------------------------------ Viewer

  # scope 'preview' do
  #   get '/' => 'previewer#dashboard', :as => :preview_dashboard
  #   scope ':site_slug' do
  #     get '/' => 'previewer#home', :as => :preview_home
  #     get '/*page_path' => 'previewer#show', :as => :preview_page
  #   end
  # end

  # ------------------------------------------ Domains

  # if ActiveRecord::Base.connection.table_exists?('sites')

  #   Site.all.each do |site|
  #     unless site.url.nil?
  #       constraints DomainConstraint.new(site.url) do
  #         get(
  #           '/' => 'viewer/pages#home',
  #           :as => :"#{site.slug}_home"
  #         )
  #         get(
  #           '/*page_path' => 'viewer/pages#show',
  #           :as => :"#{site.slug}_page"
  #         )
  #       end
  #       if site.respond_to?(:secondary_urls)
  #         site.redirect_domains.each do |domain|
  #           constraints DomainConstraint.new(domain) do
  #             get '/' => redirect("http://#{site.url}")
  #             get '/*page_path', :to => redirect { |params, request|
  #               "http://#{site.url}/#{URI.encode(params[:page_path])}"
  #             }
  #           end
  #         end
  #       end
  #     end
  #   end

  # end

  # ------------------------------------------ Home Page

  root :to => 'editor/base#home'

end
