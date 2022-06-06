class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.float :price
      t.integer :status
      t.integer :user_id
      t.integer :category_id
      t.integer :admin_id
      t.string :name
      t.string :description 

      t.timestamps
    end
  end
end
