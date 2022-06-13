class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.float :price
      t.integer :status
      t.references :users, foreign_key: true, index: true
      t.references :categories, foreign_key: true, index: true
      t.references :admins, foreign_key: true, index: true
      t.string :name
      t.string :description 

      t.timestamps
    end
  end
end
