Rails.application.routes.draw do
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

  resources :class_rooms, except: :destroy do
    resources :assignments, except: [:index, :new]
  end
  resources :user_classes, only: [:create, :destroy]
end
