# frozen_string_literal: true

module Mutations
  class DeleteComment < BaseMutation
    description "Delete a comment authored by the current user (or on their own post)"

    argument :comment_id, ID, required: true

    field :deleted_id, ID, null: true
    field :errors, [String], null: false

    def resolve(comment_id:)
      user = current_user!
      comment = Comment.find_by(id: comment_id)

      return { deleted_id: nil, errors: ["Comment not found"] } if comment.nil?

      allowed = comment.user_id == user.id || comment.post.user_id == user.id
      return { deleted_id: nil, errors: ["Not authorized to delete this comment"] } unless allowed

      comment.destroy
      { deleted_id: comment_id, errors: [] }
    end
  end
end
