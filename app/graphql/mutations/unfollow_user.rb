# frozen_string_literal: true

module Mutations
  class UnfollowUser < BaseMutation
    description "Unfollow a user"

    argument :user_id, ID, required: true

    field :user, Types::UserType, null: true, description: "The user that was unfollowed"
    field :errors, [String], null: false

    def resolve(user_id:)
      me = current_user!
      target = User.find_by(id: user_id)

      return { user: nil, errors: ["User not found"] } if target.nil?

      me.unfollow(target)
      { user: target, errors: [] }
    end
  end
end
