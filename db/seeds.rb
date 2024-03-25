# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
count = 0
User.create!(name: Faker::Name.name,
             email: 'hauphan@gmail.com',
             password: '123456',
             password_confirmation: '123456',
             activated_at: Time.zone.now,
             role: 1)

9.times do
  count += 1
  User.create!(name: Faker::Name.name,
               email: "hauphan#{count}@gmail.com",
               password: '123456',
               password_confirmation: '123456',
               activated_at: Time.zone.now,
               role: 1)
end

User.create!(name: Faker::Name.name,
             email: ENV['USER_EMAIL'],
             password: '123456',
             password_confirmation: '123456',
             activated_at: Time.zone.now,
             role: 0)

9.times do
  count += 1
  User.create!(name: Faker::Name.name,
               email: "hauphan#{count}@gmail.com",
               password: '123456',
               password_confirmation: '123456',
               activated_at: Time.zone.now,
               role: 0)
end

Category.create!(name: 'Number Bike')
Category.create!(name: 'Motor Bike')
Category.create!(name: 'Clutch Bike')

50.times do
  Bike.create!(name: "#{Faker::Vehicle.make}-#{Faker::Color.color_name}-#{rand(1000..2022)}",
               user_id: rand(1..5),
               category_id: rand(1..3),
               price: rand(1000..10_000),
               status: rand(3),
               license_plates: Faker::IDNumber.regexify(/\d{2}-[A-Z]{1}\d{1}-\d{5}/))
end

Admin.create!(name: Faker::Name.name,
              email: 'hauphan@gmail.com',
              password: '123456',
              password_confirmation: '123456',
              role: 0)
Admin.create!(name: Faker::Name.name,
              email: 'hauphan@yasuo.com',
              password: '123456',
              password_confirmation: '123456')
18.times do
  Admin.create!(name: Faker::Name.name,
                email: Faker::Internet.email,
                password: '123456',
                password_confirmation: '123456')
end
