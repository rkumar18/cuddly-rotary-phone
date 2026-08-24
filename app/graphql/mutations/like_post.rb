# frozen_string_literal: true

module Mutations
  class LikePost < BaseMutation
    description "Like a post"

    argument :post_id, ID, required: true

    field :post, Types::PostType, null: true
    field :errors, [String], null: false

    def resolve(post_id:)
      user = current_user!
      post = Post.find_by(id: post_id)

      return { post: nil, errors: ["Post not found"] } if post.nil?

      like = Like.find_or_initialize_by(user: user, post: post)
      if like.persisted? || like.save
        { post: post, errors: [] }
      else
        { post: nil, errors: like.errors.full_messages }
      end
    end
  end
end
