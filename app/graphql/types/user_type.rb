# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description "A registered user of the platform"

    field :id, ID, null: false
    field :username, String, null: false
    field :name, String, null: true
    field :bio, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    field :posts, [Types::PostType], null: false, description: "Posts authored by this user (newest first)"
    field :followers, [Types::UserType], null: false, description: "Users who follow this user"
    field :following, [Types::UserType], null: false, description: "Users this user follows"

    field :posts_count, Integer, null: false
    field :followers_count, Integer, null: false
    field :following_count, Integer, null: false

    field :followed_by_me, Boolean, null: false,
      description: "Whether the current authenticated user follows this user"

    def posts
      object.posts.recent
    end

    def posts_count
      object.posts.size
    end

    def followers_count
      object.followers.size
    end

    def following_count
      object.following.size
    end

    def followed_by_me
      viewer = context[:current_user]
      return false if viewer.nil?

      viewer.following?(object)
    end
  end
end
