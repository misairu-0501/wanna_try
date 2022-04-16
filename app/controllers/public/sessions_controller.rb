# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # ログイン後の遷移先を設定
  def after_sign_in_path_for(resource)
    my_page_user_path(resource)
  end

  # ログアウト後の遷移先を設定
  def after_sign_out_path_for(resource)
    root_path
  end

  # ゲストログイン処理
  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:notice] =  'guestuserでログインしました。'
    redirect_to  my_page_user_path(user)
  end

  # ユーザーのログインの可否を判定(カラム「is_deleted」がtrueの場合:ログインできない)
  def user_state
    @user = User.find_by(email: params[:user][:email])
    return if !@user
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted
      flash[:alert] = "ユーザーアカウントが停止されています。"
      redirect_to root_path
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
