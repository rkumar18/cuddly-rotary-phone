# frozen_string_literal: true

module Mutations
  class LogIn < BaseMutation
    description "Authenticate with email and password, returning an auth token"

    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user = User.find_by(email: email.to_s.strip.downcase)

      if user&.authenticate(password)
        token = JsonWebToken.encode(user_id: user.id)
        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: ["Invalid email or password"] }
      end
    end
  end
end
