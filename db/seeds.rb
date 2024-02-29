# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(name:  "Example User",
             email: Faker::Internet.email,
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
  Bike.create!(name: Faker::Vehicle.make+'-'+Faker::Color.color_name+'-'+rand(1000..2022).to_s,
               user_id: rand(1..2),
               category_id: rand(1..3),
               price: rand(1000..10000),
               status: rand(3),
               license_plates: Faker::IDNumber.regexify(/\d{2}-[A-Z]{1}\d{1}-\d{5}/))
end

Admin.create!(name:  "Example User",
              email: "hauphan@gmail.com",
              password:              "123456",
              password_confirmation: "123456",
              role: 0)
Admin.create!(name:  "Example User",
              email: "hauphan@yasuo.com",
              password:              "123456",
              password_confirmation: "123456")
20.times do
  Admin.create!(name: Faker::Name.name,
              email: Faker::Internet.email,
              password:              "123456",
              password_confirmation: "123456")
end
