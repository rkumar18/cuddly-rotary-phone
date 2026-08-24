# frozen_string_literal: true

module Mutations
  class DeletePost < BaseMutation
    description "Delete a post owned by the authenticated user"

    argument :post_id, ID, required: true

    field :deleted_id, ID, null: true
    field :errors, [String], null: false

    def resolve(post_id:)
      user = current_user!
      post = Post.find_by(id: post_id)

      return { deleted_id: nil, errors: ["Post not found"] } if post.nil?
      return { deleted_id: nil, errors: ["You can only delete your own posts"] } unless post.user_id == user.id

      post.destroy
      { deleted_id: post_id, errors: [] }
    end
  end
end
