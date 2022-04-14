class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_group_owner, only:[:edit, :update, :invitation_page]
  before_action :ensure_group_user, only:[:group_page, :show]

  #グループ作成画面を表示
  def index
    @user = current_user
    @groups = @user.groups
  end

  def new
    @group = Group.new
  end

  #グループを作成&グループに加入する
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      group_user = GroupUser.new
      group_user.user_id = current_user.id
      group_user.group_id = @group.id
      group_user.is_member = true
      group_user.save
      flash[:notice] = "グループ「#{@group.name}」を作成しました"
      redirect_to my_page_user_path(current_user)
    else
      render :new
    end
  end

  #グループ詳細画面を表示
  def show
    @group = Group.find(params[:id])
  end

  #グループの編集画面を表示
  def edit
    @group = Group.find(params[:id])
  end

  #グループの編集内容を更新
  def update
    if @group.update(group_params)
      flash[:notice] = "グループの情報を更新しました"
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  #グループを削除する
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "グループ「#{@group.name}」を削除しました"
    redirect_to my_page_user_path(current_user)
  end

  #グループ招待画面を表示
  def invitation_page
    @group = Group.find(params[:id])
  end

  #グループに招待する
  def invitation
    user = User.find_by(name: params[:name])
    if user
      group_user = GroupUser.find_by(user_id: user.id, group_id: params[:group_id])
    end

    #ユーザー名が未入力の場合
    if params[:name] ==""
      flash[:alert] = "ユーザー名が未入力です"
      redirect_to request.referer
    #存在しないユーザーを招待した場合
    elsif user == nil
      flash[:alert] = "#{params[:name]}さんは存在しないユーザー名です"
      redirect_to request.referer
    #既にグループに「参加」しているor「招待」されているユーザーの場合
    elsif group_user != nil
      if group_user.is_member == true
        flash[:alert] = "#{params[:name]}さんは既にグループに参加してます"
        redirect_to request.referer
      else
        flash[:alert] = "#{params[:name]}さんを既にグループに招待中です"
        redirect_to request.referer
      end
    else
      group_user = GroupUser.new
      group_user.user_id = user.id
      group_user.group_id = params[:group_id]
      group_user.save
      flash[:notice] = "#{params[:name]}さんをグループに招待しました"
      redirect_to group_path(params[:group_id])
    end
  end

  #グループの招待を受け入れて参加する
  def join
    group = Group.find(params[:id])
    group_user = GroupUser.find_by(user_id: current_user.id, group_id: group.id)
    group_user.is_member = true
    group_user.save
    flash[:notice] = "#{group.name}に参加しました"
    redirect_to group_path(group)
  end

  #グループの招待を拒否する
  def reject_invitation
    group = Group.find(params[:id])
    group_user = GroupUser.find_by(user_id: current_user.id, group_id: group.id)
    group_user.destroy
    flash[:notice] = "#{group.name}への参加を断りました"
    redirect_to my_page_user_path(current_user)
  end

  #グループを退会する
  def leave
    group = Group.find(params[:id])
    group_user = GroupUser.find_by(user_id: current_user.id, group_id: group.id)
    group_user.destroy
    flash[:notice] = "#{group.name}から退会しました"
    redirect_to my_page_user_path(current_user)
  end

  #オーナーが招待のキャンセルする
  def cancel_invitation
    user = User.find(params[:user_id])
    group = Group.find(params[:group_id])
    group_user = GroupUser.find_by(user_id: user.id, group_id: group.id)
    group_user.destroy
    flash[:notice] = "#{user.name}さんの招待をキャンセルしました"
    redirect_to group_path(group)
  end

  #オーナーがグループを強制退会させる
  def forced_leave
    user = User.find(params[:user_id])
    group = Group.find(params[:group_id])
    group_user = GroupUser.find_by(user_id: user.id, group_id: group.id)
    group_user.destroy
    flash[:notice] = "#{user.name}さんを退会させました"
    redirect_to group_path(group)
  end

  #グループの投稿一覧を表示する
  def group_page
    @group = Group.find(params[:id])
    @group_users = [] #グループ参加者(招待中は含めない)
    @group_posts = [] #グループ参加者の投稿一覧

    #グループの参加者を取得(招待中は含めない)
    @group.users.each do |user|
      if GroupUser.find_by(user_id: user.id).is_member == true
        @group_users << user
      end
    end

    #グループ参加者の投稿一覧(公開範囲「全体」「グループまで」のみ)
    @group_users.each do |user|
      user.posts.each do |post|
        if post.public_status == 0 || post.public_status == 1
          @group_posts <<  post
        end
      end
    end
    @group_posts = Kaminari.paginate_array(@group_posts).page(params[:page])
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def ensure_group_owner
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      flash[:alert] = "グループのオーナーでないと操作できません"
      redirect_to my_page_user_path(current_user)
    end
  end

  def ensure_group_user
    @group = Group.find(params[:id])
    unless GroupUser.find_by(user_id: current_user.id, group_id: @group.id)
      flash[:alert] = "参加していないグループの投稿一覧は閲覧できません"
      redirect_to my_page_user_path(current_user)
    end
  end
end
