# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(email: '123@test.com', password: '1234567890')
question = Question.create!([{ title: 'title of q1', body: 'body of q1', author: user }, { title: 'title of q2', body: 'body of q2', author: user }])
answer = Question.first.answers.create!([{ body: 'body of a1', author: user }, { body: 'body of a2', author: user }])
