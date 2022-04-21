class Public::GuestsController < ApplicationController
  def new_guest
    user = User.find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    flash[:notice] = 'ゲストユーザーとしてログインしました。'
    redirect_to my_page_user_path(user)
  end
end
