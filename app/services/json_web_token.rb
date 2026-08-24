# frozen_string_literal: true

# Small wrapper around the `jwt` gem for encoding/decoding auth tokens.
# Tokens are signed with the app's secret_key_base.
class JsonWebToken
  ALGORITHM = "HS256"
  DEFAULT_EXPIRATION = 7.days

  class << self
    def encode(payload, exp: DEFAULT_EXPIRATION.from_now)
      payload = payload.dup
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key, ALGORITHM)
    end

    # Returns the decoded payload as a HashWithIndifferentAccess, or nil if the
    # token is missing, malformed, expired, or has an invalid signature.
    def decode(token)
      return nil if token.blank?

      decoded, = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)
      ActiveSupport::HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end

    private

    def secret_key
      Rails.application.secret_key_base
    end
  end
end
