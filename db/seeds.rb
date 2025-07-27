# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample users
users = []
users << User.find_or_create_by!(name: "John Doe")
users << User.find_or_create_by!(name: "Jane Smith")
users << User.find_or_create_by!(name: "Alice Johnson")
users << User.find_or_create_by!(name: "Bob Wilson")

# Create sample rooms
Room.find_or_create_by!(name: "Game Night") do |room|
  room.user = users.first
  room.room_type = "standard"
  room.show_total_point = true
  room.limit_point = 100
  room.limit_round = 10
end

Room.find_or_create_by!(name: "Tournament") do |room|
  room.user = users.second
  room.room_type = "custom"
  room.show_total_point = false
  room.limit_point = 500
end

Room.find_or_create_by!(name: "Quick Match") do |room|
  room.user = users.third
  room.room_type = "standard"
  room.show_total_point = true
  room.limit_round = 5
end
