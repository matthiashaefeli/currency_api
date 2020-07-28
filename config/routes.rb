Rails.application.routes.draw do
  resources :users do
    collection do
      post 'login'
    end
  end

  resources :currencies do
    collection do
      get 'currency_names'
    end
  end
end
