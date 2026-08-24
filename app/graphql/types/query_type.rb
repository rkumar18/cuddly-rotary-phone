# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :me, Types::UserType, null: true,
      description: "The currently authenticated user, or null if not signed in"
    def me
      context[:current_user]
    end

    field :user, Types::UserType, null: true, description: "Look up a user by id or username" do
      argument :id, ID, required: false
      argument :username, String, required: false
    end
    def user(id: nil, username: nil)
      if id.present?
        User.find_by(id: id)
      elsif username.present?
        User.find_by(username: username)
      end
    end

    field :users, [Types::UserType], null: false, description: "List all users (newest first)"
    def users
      User.order(created_at: :desc)
    end

    field :post, Types::PostType, null: true, description: "Look up a single post by id" do
      argument :id, ID, required: true
    end
    def post(id:)
      Post.find_by(id: id)
    end

    field :posts, [Types::PostType], null: false, description: "All posts, newest first"
    def posts
      Post.recent
    end

    field :feed, [Types::PostType], null: false,
      description: "Posts from users the authenticated user follows, plus their own, newest first"
    def feed
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You must be signed in to view your feed" if user.nil?

      author_ids = user.following.pluck(:id) + [user.id]
      Post.where(user_id: author_ids).recent
    end
  end
end
