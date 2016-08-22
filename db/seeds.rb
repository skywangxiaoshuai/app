# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name:                                  "zhangsan",
                        email:                                  "zhangsan@qq.com",
                        password:                           "123456",
                        password_confirmation: "123456",
                        admin: true,
                        activated: true,
                        activated_at: Time.zone.now)
User.create!(name:                                  "wang",
                        email:                                  "741778030@qq.com",
                        password:                           "123456",
                        password_confirmation: "123456",
                        admin: true,
                        activated: true,
                        activated_at: Time.zone.now)

300.times do  |n|
    name  =  Faker::Name.name
    email  =  "example-#{n+1}@qq.com"
    password  =  "123456"

    User.create!(  name:  name,  email:  email,  password:  password,  password_confirmation:  password,
                                 activated: true,  activated_at: Time.zone.now)

    users  =  User.order(:created_at).take(50)
    6.times  do
        content  =  Faker::Lorem.sentence(5)
        users.each  {  |user|  user.microposts.create!(content:  content)  }
    end
end