class CreateBookingStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_statuses do |t|
      t.references :booking, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
