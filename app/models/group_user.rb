class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  attribute :is_member, :boolean, default: false
end
