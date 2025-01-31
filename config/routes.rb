Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root "homes#index"

  resources :certificates

  # Enroll routes (placed before `resources :courses`)
  get 'courses/enroll', to: 'courses#enroll', as: 'enroll_course'
  post 'courses/enroll/:id', to: 'courses#enroll_course', as: 'enroll_in_course'
  delete 'courses/unenroll/:id', to: 'courses#unenroll_course', as: 'unenroll_course'

  # Courses routes
  resources :courses do
    resources :quizzes
  end

  resources :teachers
  resources :students

  # Student dashboard route
  get 'student_dashboard', to: 'students#student_dashboard'

  devise_for :users
  resources :homes
  get 'about', to: 'homes#about'
  get 'contact', to: 'homes#contact'
  get 'profile', to: 'homes#profile'

  # PWA manifest route
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end