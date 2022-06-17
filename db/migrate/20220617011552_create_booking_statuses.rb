class CreateBookingStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_statuses do |t|
      t.references :booking, foreign_key: true, index: true
      t.integer :status

      t.timestamps
    end
  end
end
