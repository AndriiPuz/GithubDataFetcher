Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root 'github#search'
  get '/github/search', to: 'github#search', as: 'github_search'
  get "up" => "rails/health#show", as: :rails_health_check
end
