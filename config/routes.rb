Rails.application.routes.draw do
  resources :users do
    collection do
      post 'login'
    end
  end
end
