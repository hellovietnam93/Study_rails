Rails.application.routes.draw do
  devise_for :users

  root "static_pages#home"
  namespace :admin do
    resources :imports, only: [:index, :create]
    resources :semesters
    resources :courses
  end
end
