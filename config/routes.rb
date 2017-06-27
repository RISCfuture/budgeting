Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  constraints(->(req) { req.format == :json }) do
    resources :incomes, only: %i[index create update destroy]
    resources :expenditures, only: %i[index create update destroy]

    get 'totals' => 'totals#index'
  end

  root 'home#index'

  match '*path' => 'home#index', via: :all # Vue-Router handles all the front-end routing (routes.js)
end
