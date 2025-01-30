Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
   root "homes#index"
  resources :certificates
   resources :courses do
    resources :quizzes
  end
  resources :teachers
  resources :students
  devise_for :users
  resources :homes
  get 'about', to: 'homes#about'
  get 'contact', to: 'homes#contact'
  get 'profile', to: 'homes#profile'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  #get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
