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
    post 'guest_sign_in' => 'guests#new_guest'

    get 'search/search_input'
    get 'search/search_result'

    resources :users, only:[:edit, :index, :show, :update] do
      member do
        get 'my_page'
        get 'my_favorite'
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
    resources :groups, only: [:new, :create, :show, :edit, :update, :destroy, :index] do
      member do
        get 'invitation_page'
        post 'invitation'
        patch 'join'
        delete 'reject_invitation'
        delete 'leave'
        delete 'cancel_invitation'
        delete 'forced_leave'
        get 'group_page'
      end
    end
  end
end