class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update]

  #グループ作成画面を表示
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
      flash[:notice] = "グループを作成しました"
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
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  #グループを削除する
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "グループを削除しました"
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

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      flash[:alert] = "グループのオーナーでないため編集できません"
      redirect_to my_page_user_path(current_user)
    end
  end

end
