Rails.application.routes.draw do
  namespace :admins_backoffice do
    get 'subjects/index'
  end
  namespace :admins_backoffice do
    get 'welcome/index' 
    resources :admins
    resources :subjects
    resources :questions
  end
  namespace :site do
    get 'welcome/index'
    get 'search', to: 'search#questions'
    get 'subject/:subject_id/:subject', to: 'search#subjects', as: 'search_subject'
    post 'answer', to: 'answer#question'
  end
  namespace :users_backoffice do
    get 'welcome/index' 
  end

  devise_for :admins
  devise_for :users
  
  get 'inicio', to: 'site/welcome#index'
  root to: 'site/welcome#index'

end