# frozen_string_literal: true

class RenameAdminToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    rename_table :admins, :admin_users
  end
end
