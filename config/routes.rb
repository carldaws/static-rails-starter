Rails.application.routes.draw do
  resources :pages, param: :slug, path: ''
  
  root "pages#index"
end
