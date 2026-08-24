# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    description "A post authored by a user"

    field :id, ID, null: false
    field :body, String, null: false
    field :author, Types::UserType, null: false, description: "The user who wrote the post"
    field :comments, [Types::CommentType], null: false, description: "Comments on the post (newest first)"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :likes_count, Integer, null: false
    field :comments_count, Integer, null: false
    field :liked_by_me, Boolean, null: false,
      description: "Whether the current authenticated user has liked this post"

    def author
      object.user
    end

    def comments
      object.comments.recent
    end

    def likes_count
      object.likes.size
    end

    def comments_count
      object.comments.size
    end

    def liked_by_me
      object.liked_by?(context[:current_user])
    end
  end
end
