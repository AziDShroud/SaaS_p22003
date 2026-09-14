# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Post.destroy_all
Category.destroy_all
User.destroy_all
Group.destroy_all

# Create Categories
web_dev = Category.create(name: "Web Development")
ai_lab = Category.create(name: "AI & Machine Learning Lab")

# Create Users
alice = User.create!(name: "Alice Smith", email: "alice@example.com")
bob = User.create!(name: "Bob Jones",email: "bob@example.com")

# Setting up Contacts & Groups
alice.personal_contacts << bob

lab_group = Group.create!(name: "Rails Lab Team", description: "Ruby Development")
lab_group.users << [alice, bob]

# Create Posts
Post.create!(title: "Looking for team members in Rails", content: "Hi! Need 2 more members for the web dev projects", user: alice, category: web_dev)
Post.create!(title: "Python AI Homework Help", content: "Anyone interested in reviewing model architectures", user: bob, category: ai_lab)
