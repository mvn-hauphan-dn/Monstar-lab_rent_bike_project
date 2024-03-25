# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :user, foreign_key: true, index: true
      t.references :bike, foreign_key: true, index: true
      t.date :booking_start_day
      t.date :booking_end_day
      t.string :comment
      t.integer :rating

      t.timestamps
    end
  end
end
