Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  root "homes#index"


  # Enroll routes (placed before `resources :courses`)
  get "courses/enroll", to: "courses#enroll", as: "enroll_course"
  post "courses/enroll/:id", to: "courses#enroll_course", as: "enroll_in_course"
  delete "courses/unenroll/:id", to: "courses#unenroll_course", as: "unenroll_course"

  # Courses routes
  resources :courses do
    resources :certificates
    member do
    get :enrolled_students, :quiz_result
  end
    post :complete_video, on: :member
    resources :quizzes do 
       collection do
      get 'quiz_statistics'
    end
       member do
    get 'attempt'
    post 'submit'
  end
      
    end
  end


  resources :teachers
  get 'teacher_dashboard', to: 'teachers#teacher_dashboard'


    resources :students
    get "student_dashboard", to: "students#student_dashboard"

  devise_for :users
  resources :homes
  get "about", to: "homes#about"
  get "contact", to: "homes#contact"
  get "profile", to: "homes#profile"
  

  # Student routes
  authenticated :user, ->(user) { user.student? } do
    root 'student_dashboard#index', as: :student_root
    get 'student_dashboard', to: 'student_dashboard#index'
  end

  # Teacher routes
  authenticated :user, ->(user) { user.teacher? } do
    root 'teacher_dashboard#index', as: :teacher_root
    get 'teacher_dashboard', to: 'teacher_dashboard#index'
  end


  # Catch-all route for handling 404 errors
  match '*path', to: 'errors#not_found', via: :all

  # PWA manifest route
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
