# frozen_string_literal: true

module Mutations
  class UnlikePost < BaseMutation
    description "Remove a like from a post"

    argument :post_id, ID, required: true

    field :post, Types::PostType, null: true
    field :errors, [String], null: false

    def resolve(post_id:)
      user = current_user!
      post = Post.find_by(id: post_id)

      return { post: nil, errors: ["Post not found"] } if post.nil?

      Like.where(user: user, post: post).destroy_all
      { post: post, errors: [] }
    end
  end
end
