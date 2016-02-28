Rails.application.routes.draw do
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
    resources :assignments, except: [:index, :new]
    resources :questions, except: :index
    resources :online_tests
    resources :assignment_submits, except: [:index, :new, :edit]
    resources :assignment_histories
    resources :forums
  end

  resources :forums, only: :show do
    resources :posts
  end

  resources :post, only: :show do
    resources :comments
  end
  resources :semesters, only: [:index, :show]
  resources :user_classes, only: [:create, :destroy]
end
