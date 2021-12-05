Rails.application.routes.draw do
  #Signup route for researcher
  resource  :signup, only: %i[create]

  #Authorization Token generator for reseacher endpoint consumption 
  resources :authentications, only: %i[create]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :experiments, only: [:index, :create]
    end
  end

end
