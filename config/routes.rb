Rails.application.routes.draw do
  get 'documents/index'

  get 'documents/new'

  get 'documents/create'

  get 'documents/destroy'

  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users

  root "static_pages#home"
  namespace :admin do
    root "courses#index"
    resources :imports, only: [:index, :create]
    resources :semesters
    resources :courses do
      resources :class_rooms, except: [:index, :new]
    end
    resources :class_rooms
  end

  resources :class_rooms, only: [:index, :show, :update] do
    resources :assignments
    resources :questions
    resources :online_tests
    resources :assignment_submits
    resources :assignment_histories
    resources :timetables
    resources :documents, only: [:index, :create, :destroy]
    resources :teams do
      resource :class_team
    end
  end

  resources :forums, only: :show do
    resources :posts
  end

  resources :post, only: :show do
    resources :comments
  end

  resources :comments, only: [:index, :create]
  get "/comments/new/(:parent_id)", to: "comments#new", as: :new_comment

  resources :semesters, only: [:index, :show]
  resources :user_classes, only: [:create, :destroy]
  resources :class_room_requests, only: [:create, :update, :destroy]

  resources :users, only: :show do
    resources :likes
  end
  resources :groups, except: [:index, :new]
  resources :group_users
  resources :users, only: :show
  resources :event_users, only: :update
end
