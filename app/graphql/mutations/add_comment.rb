# frozen_string_literal: true

module Mutations
  class AddComment < BaseMutation
    description "Add a comment to a post"

    argument :post_id, ID, required: true
    argument :body, String, required: true

    field :comment, Types::CommentType, null: true
    field :errors, [String], null: false

    def resolve(post_id:, body:)
      user = current_user!
      post = Post.find_by(id: post_id)

      return { comment: nil, errors: ["Post not found"] } if post.nil?

      comment = post.comments.build(user: user, body: body)
      if comment.save
        { comment: comment, errors: [] }
      else
        { comment: nil, errors: comment.errors.full_messages }
      end
    end
  end
end
