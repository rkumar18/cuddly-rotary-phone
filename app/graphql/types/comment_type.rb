# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    description "A comment on a post"

    field :id, ID, null: false
    field :body, String, null: false
    field :user, Types::UserType, null: false, description: "The author of the comment"
    field :post, Types::PostType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
