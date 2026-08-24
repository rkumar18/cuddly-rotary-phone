# frozen_string_literal: true

module Mutations
  class FollowUser < BaseMutation
    description "Follow another user"

    argument :user_id, ID, required: true

    field :user, Types::UserType, null: true, description: "The user that was followed"
    field :errors, [String], null: false

    def resolve(user_id:)
      me = current_user!
      target = User.find_by(id: user_id)

      return { user: nil, errors: ["User not found"] } if target.nil?
      return { user: nil, errors: ["You can't follow yourself"] } if target == me

      if me.follow(target)
        { user: target, errors: [] }
      else
        { user: nil, errors: ["Unable to follow user"] }
      end
    end
  end
end
