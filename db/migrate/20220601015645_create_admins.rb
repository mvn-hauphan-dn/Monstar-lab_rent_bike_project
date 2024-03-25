# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email, index: { unique: true }
      t.string :password_digest
      t.string :remember_digest
      t.integer :role, default: 1

      t.timestamps
    end
  end
end
