Rails.application.routes.draw do
  resources :aeropuertos, :controller => :contents, :except => [:index, :show], :path => 'content'
end

