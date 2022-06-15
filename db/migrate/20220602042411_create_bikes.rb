class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.float :price
      t.integer :status
      t.references :user, foreign_key: true, index: true
      t.references :category, foreign_key: true, index: true
      t.references :admin, foreign_key: true, index: true
      t.string :name
      t.string :description 
      t.string :license_plates, index: { unique: true }

      t.timestamps
    end
  end
end
