class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.float :price
      t.integer :status
      t.reference :users, foreign_key: true, index: true
      t.reference :categories, foreign_key: true, index: true
      t.reference :admins, foreign_key: true, index: true
      t.string :name
      t.string :description 

      t.timestamps
    end
  end
end
