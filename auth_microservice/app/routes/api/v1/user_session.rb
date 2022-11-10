# frozen_string_literal: true

class AuthMicroservice
  include Validations
  include ApiErrors

  hash_path('/api/v1/user_session') do |r|
    r.is do
      r.post do
        session_params = validate_with!(SessionParamsContract)

        result = UserSessions::CreateService.call(*session_params.to_h.values)

        if result.success?
          token = JwtEncoder.encode(uuid: result.session.uuid)
          meta = { token: token }

          response.status = 201
          { meta: meta }
        else
          response.status = 401
          error_response(result.session || result.errors)
        end
      end
    end
  end
end
