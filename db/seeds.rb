# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding sample social data..."

users = [
  { username: "alice", email: "alice@example.com", name: "Alice Anderson", bio: "Coffee, code, and cats." },
  { username: "bob",   email: "bob@example.com",   name: "Bob Brown",      bio: "Just here for the memes." },
  { username: "carol", email: "carol@example.com", name: "Carol Clark",   bio: "Photographer and traveller." }
].map do |attrs|
  User.find_or_create_by!(username: attrs[:username]) do |u|
    u.email = attrs[:email]
    u.name = attrs[:name]
    u.bio = attrs[:bio]
    u.password = "password123"
  end
end

alice, bob, carol = users

# Social graph
alice.follow(bob)
alice.follow(carol)
bob.follow(alice)
carol.follow(alice)

# Posts
p1 = alice.posts.find_or_create_by!(body: "Hello world! First post on the new GraphQL app.")
p2 = bob.posts.find_or_create_by!(body: "GraphQL over REST any day.")
p3 = carol.posts.find_or_create_by!(body: "Sunset shots from the weekend trip.")

# Likes
Like.find_or_create_by!(user: bob, post: p1)
Like.find_or_create_by!(user: carol, post: p1)
Like.find_or_create_by!(user: alice, post: p2)

# Comments
p1.comments.find_or_create_by!(user: bob, body: "Welcome aboard!")
p1.comments.find_or_create_by!(user: carol, body: "Looks great.")
p2.comments.find_or_create_by!(user: alice, body: "Totally agree.")

puts "Done. Users: #{User.count}, Posts: #{Post.count}, Follows: #{Follow.count}, Likes: #{Like.count}, Comments: #{Comment.count}"
puts "Sample login -> email: alice@example.com, password: password123"
