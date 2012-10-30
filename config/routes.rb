PaymentsDemo::Application.routes.draw do
  resources :payments do
    resources :payment_events, :only => [:update]
  end

  root :to => "payments#index"
end
