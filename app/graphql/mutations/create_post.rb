# frozen_string_literal: true

module Mutations
  class CreatePost < BaseMutation
    description "Create a new post as the authenticated user"

    argument :body, String, required: true

    field :post, Types::PostType, null: true
    field :errors, [String], null: false

    def resolve(body:)
      user = current_user!
      post = user.posts.build(body: body)

      if post.save
        { post: post, errors: [] }
      else
        { post: nil, errors: post.errors.full_messages }
      end
    end
  end
end
