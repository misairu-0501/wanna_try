class RenameOwnerColumnToGroups < ActiveRecord::Migration[6.1]
  def change
    rename_column :groups, :owner, :owner_id
  end
end
