# frozen_string_literal: true

module Auth
  class Unauthorized < StandardError; end

  AUTH_TOKEN = /\ABearer (?<token>.+)\z/.freeze

  def user_id
    user_id = auth_service.auth(matched_token)
    raise Unauthorized if user_id.blank?

    AdsMicroservice.logger.info(
      'Request a user ID',
      user: user_id
    )

    user_id
  end

  private

  def auth_service
    @auth_service ||= AuthService::Client.new
  end

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_header
    request.env['HTTP_AUTHORIZATION']
  end
end
