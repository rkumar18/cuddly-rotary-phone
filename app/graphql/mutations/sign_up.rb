# frozen_string_literal: true

module Mutations
  class SignUp < BaseMutation
    description "Register a new user and return an auth token"

    argument :username, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :name, String, required: false
    argument :bio, String, required: false

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(username:, email:, password:, name: nil, bio: nil)
      user = User.new(username: username, email: email, password: password, name: name, bio: bio)

      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: user.errors.full_messages }
      end
    end
  end
end
