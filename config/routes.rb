Rails.application.routes.draw do

  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  namespace :admin do
    resources :genres, only:[:index, :create, :edit, :update]
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
    resources :users, only:[:edit, :index, :show, :update] do
      member do
        get 'my_page'
      end
      resource :relationships, only:[:create, :destroy] do
        member do
          get 'followings'
          get 'followers'
        end
      end
    end
    resources :children, only:[:new, :create, :edit, :update, :destroy]
    resources :posts, only:[:new, :create, :edit, :update, :index, :show, :destroy] do
      resources :post_comments, only:[:create, :destroy]
      resource :favorites, only:[:create, :destroy]
    end
  end
end