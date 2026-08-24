# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    private

    # Returns the authenticated user or raises a GraphQL error usable by clients.
    def current_user!
      context[:current_user] || raise(GraphQL::ExecutionError, "You must be signed in to perform this action")
    end
  end
end
