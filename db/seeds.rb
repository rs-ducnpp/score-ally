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
game_night_room = Room.find_or_create_by!(name: "Game Night") do |room|
  room.user = users.first
  room.room_type = "standard"
  room.show_total_point = true
  room.limit_point = 100
  room.limit_round = 10
end

tournament_room = Room.find_or_create_by!(name: "Tournament") do |room|
  room.user = users.second
  room.room_type = "custom"
  room.show_total_point = false
  room.limit_point = 500
end

quick_match_room = Room.find_or_create_by!(name: "Quick Match") do |room|
  room.user = users.third
  room.room_type = "standard"
  room.show_total_point = true
  room.limit_round = 5
end

# Create sample rules
rules = []

# Rules for Game Night room
rules << Rule.find_or_create_by!(room: game_night_room, point_type: "score", point: 10) do |rule|
  rule.description = "Win a round"
end

rules << Rule.find_or_create_by!(room: game_night_room, point_type: "penalty", point: 5) do |rule|
  rule.description = "Lose a round"
end

rules << Rule.find_or_create_by!(room: game_night_room, point_type: "score", point: 20) do |rule|
  rule.description = "Perfect score"
end

# Rules for Tournament room
rules << Rule.find_or_create_by!(room: tournament_room, point_type: "score", point: 50) do |rule|
  rule.description = "Tournament victory"
end

rules << Rule.find_or_create_by!(room: tournament_room, point_type: "penalty", point: 25) do |rule|
  rule.description = "Tournament defeat"
end

# Rules for Quick Match room
rules << Rule.find_or_create_by!(room: quick_match_room, point_type: "score", point: 15) do |rule|
  rule.description = "Quick win"
end

# Create sample chart data (game history)
# Game Night Room - Round 1
Chart.find_or_create_by!(user: users[0], room: game_night_room, rule: rules[0], round: 1) do |chart|
  chart.point = 10
end

Chart.find_or_create_by!(user: users[1], room: game_night_room, rule: rules[1], round: 1) do |chart|
  chart.point = -5
end

# Game Night Room - Round 2
Chart.find_or_create_by!(user: users[1], room: game_night_room, rule: rules[2], round: 2) do |chart|
  chart.point = 20
end

Chart.find_or_create_by!(user: users[0], room: game_night_room, rule: rules[0], round: 2) do |chart|
  chart.point = 10
end
