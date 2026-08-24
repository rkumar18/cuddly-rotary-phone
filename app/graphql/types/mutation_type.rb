# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Auth
    field :sign_up, mutation: Mutations::SignUp
    field :log_in, mutation: Mutations::LogIn

    # Posts
    field :create_post, mutation: Mutations::CreatePost
    field :delete_post, mutation: Mutations::DeletePost

    # Social graph
    field :follow_user, mutation: Mutations::FollowUser
    field :unfollow_user, mutation: Mutations::UnfollowUser

    # Likes
    field :like_post, mutation: Mutations::LikePost
    field :unlike_post, mutation: Mutations::UnlikePost

    # Comments
    field :add_comment, mutation: Mutations::AddComment
    field :delete_comment, mutation: Mutations::DeleteComment
  end
end
