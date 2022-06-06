class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :calendars do |t|
      t.date :start_day
      t.date :end_day
      t.integer :bike_id

      t.timestamps
    end
  end
end
