class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :calendars do |t|
      t.date :start_day
      t.date :end_day
      t.integer :bikes, foreign_key: true, index: true

      t.timestamps
    end
  end
end
