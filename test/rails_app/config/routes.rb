Rails.application.routes.draw do
  root "pages#about"
  get "excluded", to: "pages#excluded"
end
