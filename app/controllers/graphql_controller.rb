# frozen_string_literal: true

class GraphqlController < ApplicationController
  # This is an API endpoint consumed by non-browser clients (GraphiQL, mobile,
  # etc.), so skip the browser gate and CSRF token requirement. Auth is handled
  # per-request via a JWT in the Authorization header.
  skip_before_action :verify_authenticity_token, raise: false
  skip_forgery_protection

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user
    }
    result = DemoGraphSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Resolves the authenticated user from a "Authorization: Bearer <token>"
  # header. Returns nil when absent or invalid (queries/mutations decide whether
  # authentication is required).
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = begin
      header = request.headers["Authorization"]
      token = header.to_s.split(" ").last
      payload = JsonWebToken.decode(token)
      payload && User.find_by(id: payload[:user_id])
    end
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
