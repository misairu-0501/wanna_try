class ApplicationController < ActionController::Base
  
  #二人のユーザーが同じグループに所属しているか調べる(同じグループに所属：true)
  def same_group?(user1_id, user2_id)
    flag = false
    GroupUser.where(user_id: user1_id, is_member: true).each do |group_user1|
      GroupUser.where(user_id: user2_id, is_member: true).each do |group_user2|
        if group_user1.group_id == group_user2.group_id
          flag = true
          break
        end
      end
    end
    flag
  end
end
