Blogger::Application.routes.draw do
	root to: 'hosts#index' 
	resources :articles

	resources :articles do
  		resources :comments
	end

	resources :tags		
	
	resources :hosts 
	match '/listAll',  to: 'hosts#listAllHost',            via: 'get'
end
