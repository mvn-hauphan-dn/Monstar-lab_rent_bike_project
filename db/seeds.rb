# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(name:  "Example User",
             email: ENV["USER_EMAIL"],
             password:              "123456",
             password_confirmation: "123456",
             activated_at: Time.zone.now,
             role: 0)

User.create!(name:  "Example User",
             email: "hauphan@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             activated_at: Time.zone.now,
             role: 1)

Category.create!(name: "Number Bike")
Category.create!(name: "Motor Bike")
Category.create!(name: "Clutch Bike")

30.times do 
  Bike.create!(name: "ssssssssss",
               user_id: 1,
               category_id: 1,
               price: 1000,
               status: 1)
end
